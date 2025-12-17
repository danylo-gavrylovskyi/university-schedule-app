import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let loadingVC = UIViewController()
        loadingVC.view.backgroundColor = .white
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loadingVC.view.center
        spinner.startAnimating()
        loadingVC.view.addSubview(spinner)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = loadingVC
        self.window = window
        window.makeKeyAndVisible()
        
        let lessonRepo = InMemoryLessonRepository()
        let userRepo = InMemoryUserRepository()
        
        Task {
            let allLessons = await lessonRepo.getAllLessons()
            let allIds = Set(allLessons.map { $0.id })
            await userRepo.seedUser(with: allIds)
            
            let service = ScheduleService(userRepo: userRepo, lessonRepo: lessonRepo)
            
            // 3. Create the Real App Screen with Dependencies
            await MainActor.run {
                // Now we can use our clean init!
                let mainVC = ScheduleViewController(service: service, userId: testUserId)
                let navVC = UINavigationController(rootViewController: mainVC)
                
                // Swap the root view controller smoothly
                window.rootViewController = navVC
            }
        }
    }
}
