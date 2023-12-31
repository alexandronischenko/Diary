import UIKit
import RealmSwift
import Realm

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var window: UIWindow?
        window = UIWindow()

        // MARK: - Была загрузка из JSON файла
//        if let notes = FileReader.shared.loadJson() {
//            let realm = try! Realm()
//            print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
//            let entities = notes.map { note in
//                NoteEntity(from: note)
//            }
//            try! realm.write({
//                realm.add(entities)
//            })
//        }

        let viewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
