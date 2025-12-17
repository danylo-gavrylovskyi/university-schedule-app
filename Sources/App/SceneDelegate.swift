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
        
        let userRepo = InMemoryUserRepository(initialUsers: MockData.users)
        let lessonRepo = InMemoryLessonRepository(initialLessons: MockData.lessons)
        
        let validationService = ValidationService()
        let scheduleService = ScheduleService(lessonRepository: lessonRepo, validationService: validationService)
        let studentScheduleService = StudentScheduleService(lessonRepository: lessonRepo)
        let authService = AuthService(userRepository: userRepo)
        
        // Init the viewModels and Controllers here...
    }
}
