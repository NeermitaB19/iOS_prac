//
//  SceneDelegate.swift
//  UIKit
//
//  Created by neermita.bhattacharya@wbd.com on 19/08/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
// rsponsible for holding thr window/ managaing windows together
    //scene is one level below app delegate
    //when window entered background ? foreground?
        // one app can have multiple windows. scene 1 - window 1, scene 2 - window 2. each scene has its own UI/window lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
/*
 1. scene(_:willConnectTo:options:)
 2. sceneDidDisconnect(_:)
 3. sceneDidBecomeActive(_:)
 4. sceneWillResignActive(_:)
 5. sceneWillEnterForeground(_:)
 6. sceneDidEnterBackground(_:)
 */

//uikit
/*
 AppDelegate
      ↓
 SceneDelegate
      ↓
 UIWindow
      ↓
 Root ViewController
      ↓
 Other ViewControllers

 */


//swiftui
/*
 @main App
      ↓
 WindowGroup
      ↓
 ContentView
      ↓
 Other SwiftUI Views

 */

//MARK: APP LIFECYCLE
/*
 app launches - not running - inactive - active
 ios controls when your app moves between these states
 
 User taps app
      ↓
 iOS starts application
      ↓
 AppDelegate
      ↓
 Scene created
      ↓
 SceneDelegate
      ↓
 Window/UI created
      ↓
 App becomes active

 
 SceneDelegate
      ↓
 UIWindow
      ↓
 NavigationController
      ↓
 Coordinator
      ↓
 First ViewController

 
 Your App
    ↓
 User presses Home / swipes away
    ↓
 Background

 Background
     ↓
 Suspended

 app remains in memory but execution is paused
 
 Suspended
     ↓
 Terminated

 */
//MARK: ViewController Lifecycle
/*
 UIViewController = manages the screen
 UIView           = the actual visual stuff on the screen

 init
   ↓
 loadView (If you want to perform any additional initialization of your views, do so in the viewDidLoad() method. You should never call this method directly)
   ↓
 viewDidLoad (one time setup - configure ui, set delegates etc)
   ↓
 viewWillAppear (refresh data here)
   ↓
 viewDidAppear (start animation)
   ↓
    [user uses screen]
   ↓
 viewWillDisappear
   ↓
 viewDidDisappear

 */
