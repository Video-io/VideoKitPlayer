//
//  AppDelegate.swift
//  VideoKitPlayer
//
//  Created by Dennis Stücken on 3/1/21.
//
import UIKit
import VideoKitCore

extension Notification.Name {
    static let videoKitReady = Notification.Name("videoKitReady")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var videoKitReady: Bool = false {
        didSet {
            if videoKitReady {
                NotificationCenter.default.post(name: .videoKitReady, object: nil)
            }
        }
    }
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector:  #selector(self.vkitSignedIn), name: .VKAccountStateChanged, object: nil)
        
        // 1. Retrieve session token, check docs on https://docs.video.io/docs/ios/session for more information
        // ...
        struct SessionResponse: Decodable {
            var sessionToken: String
            var identity: String
            var expiresAt: String
        }
        
        if let url = URL(string: "https://videokit-node-js-example-33sztycg3fx6.runkit.sh/token/unique-user-id") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let res = try JSONDecoder().decode(SessionResponse.self, from: data)
                    
                    // 2. Start session with retrieved session token
                    VKSession.current.start(sessionToken: res.sessionToken)
                    
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
        
        return true
    }
    
    @objc func vkitSignedIn() {
        videoKitReady = true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

