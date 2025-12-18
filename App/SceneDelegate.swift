import UIKit
import UniversityScheduleCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let loadingVC = UIViewController()
        loadingVC.view.backgroundColor = .white
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = loadingVC
        self.window = window
        window.makeKeyAndVisible()
        
        let userRepo = InMemoryUserRepository(initialUsers: MockData.users)
        let lessonRepo = InMemoryLessonRepository(initialLessons: MockData.lessons)
        
        let validationService = ValidationService()
        let scheduleService = ScheduleService(lessonRepository: lessonRepo, validationService: validationService)
        // not for demo
        // let studentScheduleService = StudentScheduleService(lessonRepository: lessonRepo)
        // not for demo
        // let authService = AuthService(userRepository: userRepo)
        
        let lessonsViewModel = LessonsViewModel(scheduleService: scheduleService)
        let adminVC = AdminScheduleViewController(
            viewModel: lessonsViewModel,
            scheduleService: scheduleService
        )
        
        let studentId = MockData.users.first(where: { $0.role == .student })?.id ?? UUID()
        
        let studentVC = ScheduleViewController(
            service: scheduleService, // not for demo use studentScheduleService
            userId: studentId
        )
        
        let adminNav = UINavigationController(rootViewController: adminVC)
        adminNav.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "lock.shield"), tag: 0)
        
        let studentNav = UINavigationController(rootViewController: studentVC)
        studentNav.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(systemName: "calendar"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [studentNav, adminNav]
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        window.rootViewController = tabBarController
    }
}
