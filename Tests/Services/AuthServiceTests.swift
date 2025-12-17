import XCTest
@testable import university_schedule_app

final class AuthServiceTests: XCTestCase {
    
    var authService: AuthService!
    var userRepository: InMemoryUserRepository!
    
    override func setUp() async throws {
        userRepository = InMemoryUserRepository()
        authService = AuthService(userRepository: userRepository)
        
        for user in MockData.users {
            _ = await userRepository.addUser(user)
        }
    }
    
    override func tearDown() {
        authService = nil
        userRepository = nil
    }
    
    func testLoginWithCorrectCredentials() async {
        let user = await authService.login(email: "admin@kse.org.ua", password: "admin123")
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.email, "admin@kse.org.ua")
        XCTAssertEqual(user?.role, .admin)
    }
    
    func testLoginWithIncorrectPassword() async {
        let user = await authService.login(email: "admin@kse.org.ua", password: "wrongpassword")
        
        XCTAssertNil(user)
    }
    
    func testLoginWithEmptyCredentials() async {
        let user1 = await authService.login(email: "", password: "admin123")
        let user2 = await authService.login(email: "admin@kse.org.ua", password: "")
        
        XCTAssertNil(user1)
        XCTAssertNil(user2)
    }
    
    func testGetCurrentUserAfterLogin() async {
        _ = await authService.login(email: "student@kse.org.ua", password: "student123")
        
        let currentUser = authService.getCurrentUser()
        
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.role, .student)
    }
    
    func testLogout() async {
        _ = await authService.login(email: "admin@kse.org.ua", password: "admin123")
        XCTAssertNotNil(authService.getCurrentUser())
        
        authService.logout()
        
        XCTAssertNil(authService.getCurrentUser())
    }
}
