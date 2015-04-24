import UIKit
import Alamofire
import JsonSwiftson

struct Application {
    let app_key : NSString
    let app_type : NSString
    let icon_url : NSString
    let package : NSString
    let name : NSString
}

class AnarchoAPI: NSObject {
   
    func autorizaetion() {
        Alamofire.request(.POST, "http://anarcho.pp.ciklum.com/api/login",
            parameters: ["email" : "dsay@ciklum.com", "password" : "8hYDrdiv"],  encoding: .JSON)
            .validate(statusCode: 200..<200)
            .validate(contentType: ["application/json"])
            .responseString(encoding: NSUTF8StringEncoding) { (_, _, string, _) -> Void in
                var mapper = JsonSwiftson(json: string!)
                let token : NSString = mapper["authToken"].map()!
                Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["x-auth-token" :token]
                self.getApps()
        }
    }
    
    func getApps() {
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
                    }!
                println(applications)
        }
    }
}
