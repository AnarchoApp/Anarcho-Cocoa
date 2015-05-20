import UIKit
import Alamofire
import JsonSwiftson

public struct Application {
    let app_key : NSString
    let app_type : NSString
    let icon_url : NSString
    let package : NSString
    let name : NSString
}

public struct Build {
    let id : NSInteger
    let created_on : NSTimeInterval
    let release_notes : NSString
    let version_code : NSString
    let version_name : NSString
}

public typealias completion = () -> Void

public let kAuthorization = "http://anarcho.pp.ciklum.com/api/login"
public let kApps = "http://anarcho.pp.ciklum.com/api/apps/"

public class AnarchoAPI{
    public func authorization(email: NSString!, password: NSString!, completionBlock: completion? = nil) -> Self{
        Alamofire.request(.POST, kAuthorization,
            parameters: ["email" : email, "password" : password],  encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                if let json = string{
                    var mapper = JsonSwiftson(json: json)
                    let token : NSString = mapper["authToken"].map()!
                    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["x-auth-token" :token]
                }
                if let block = completionBlock {
                    block()
                }
        }
        return self
    }
    
    public func getApps(completion: (applications: [Application]) -> Void) -> Self{
        Alamofire.request(.GET, kApps)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                if let json = string{
                    var mapper = JsonSwiftson(json: json)
                    let applications : [Application] = mapper["list"].mapArrayOfObjects { j in
                        Application(
                            app_key: j["app_key"].map()!,
                            app_type: j["app_type"].map()!,
                            icon_url: j["icon_url"].map()!,
                            package: j["package"].map()!,
                            name: j["name"].map()!)
                        } ?? []
                    completion(applications: applications)
                }else{
                    completion(applications: [])
                }
        }
        return self
    }
    
    public func getBuilds(appKey: NSString, completion: (builds: [Build]) -> Void) -> Self{
        Alamofire.request(.GET, "\(kApps)\(appKey)/builds")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                if let json = string{
                    var mapper = JsonSwiftson(json: json)
                    let builds : [Build] = mapper["list"].mapArrayOfObjects { j in
                        Build(
                            id: j["id"].map()!,
                            created_on: j["created_on"].map()!,
                            release_notes: j["release_notes"].map()!,
                            version_code: j["version_code"].map()!,
                            version_name: j["version_name"].map()!)
                        } ?? []
                    completion(builds: builds)
                }else{
                    completion(builds: [])
                }
        }
        return self
    }
}

class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            var data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            var downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadTask.resume()
        })
    }
}