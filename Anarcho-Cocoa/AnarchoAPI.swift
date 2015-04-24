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

public typealias completion = () -> Void

public class AnarchoAPI{
    public func autorizaetion(completionBlock: completion? = nil) -> Self{
        Alamofire.request(.POST, "http://anarcho.pp.ciklum.com/api/login",
            parameters: ["email" : "dsay@ciklum.com", "password" : "8hYDrdiv"],  encoding: .JSON)
            .validate(statusCode: 200..<200)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                var mapper = JsonSwiftson(json: string!)
                let token : NSString = mapper["authToken"].map()!
                Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["x-auth-token" :token]
                if let block = completionBlock {
                    block()
                }
        }
        return self
    }
    
    public func getApps(completion: (applications: [Application]) -> Void) -> Self{
        Alamofire.request(.GET, "http://anarcho.pp.ciklum.com/api/apps")
            .validate(statusCode: 200..<200)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                var mapper = JsonSwiftson(json: string!)
                let applications : [Application] = mapper["list"].mapArrayOfObjects { j in
                    Application(
                        app_key: j["app_key"].map()!,
                        app_type: j["app_type"].map()!,
                        icon_url: j["icon_url"].map()!,
                        package: j["package"].map()!,
                        name: j["name"].map()!)
                    } ?? []
                completion(applications: applications)
        }
        return self
    }
    
//    public func then(fungg: () -> Self) -> Self {
//        return self
//    }
}
