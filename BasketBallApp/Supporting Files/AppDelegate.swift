import UIKit
import CoreData

//TODO: experiment with swinject https://www.raywenderlich.com/17-swinject-tutorial-for-ios-getting-started
//https://github.com/Swinject/Swinject
//https://github.com/Swinject/SwinjectStoryboard
//https://itnext.io/dependency-injection-with-swinject-73f3144b20f0
//https://github.com/Swinject/SwinjectSimpleExample pull this example and experiment

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		return true
	}

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
	}

}
