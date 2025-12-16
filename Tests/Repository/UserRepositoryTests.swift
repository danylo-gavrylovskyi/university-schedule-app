import XCTest
@testable import university_schedule_app

final class UserRepositoryTests: XCTestCase {
    
    func testGetAllUsers() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let users = await repo.getAllUsers()
        
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.id, user1.id)
        XCTAssertEqual(users.last?.id, user2.id)
    }
    
    func testGetUserById() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.getUserById(user2.id)
        
        XCTAssertNotEqual(user, nil)
        XCTAssertEqual(user?.id, user2.id)
        XCTAssertEqual(user?.passwordHash, user2.passwordHash)
    }
    
    func testGetUserByIdWithWrongIdReturnsNil() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.getUserById(UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)
        
        XCTAssertEqual(user, nil)
    }
    
    func testGetUserByEmail() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.getUserByEmail(user2.email)
        
        XCTAssertNotEqual(user, nil)
        XCTAssertEqual(user?.id, user2.id)
        XCTAssertEqual(user?.passwordHash, user2.passwordHash)
    }
    
    func testGetUserByEmailWithWrongIdReturnsNil() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.getUserByEmail("wrongEmail")
        
        XCTAssertEqual(user, nil)
    }
    
    func testExistsUserByEmail() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.existsUserByEmail(user2.email)
        
        XCTAssertEqual(user, true)
    }
    
    func testExistsUserByEmailWithWrongEmailReturnsFalse() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let _ = await repo.addUser(user2)
        let user = await repo.existsUserByEmail("wrongEmail")
        
        XCTAssertEqual(user, false)
    }
    
    func testAddUser() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        
        let _ = await repo.addUser(user1)
        let users = await repo.getAllUsers()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.id, user1.id)
        XCTAssertEqual(users.first?.email, user1.email)
        XCTAssertEqual(users.first?.passwordHash, user1.passwordHash)
        XCTAssertEqual(users.first?.role, user1.role)
    }
    
    func testUpdateUserWhichDoesntExistReturnsNil() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        
        let updatedUser = await repo.updateUser(id: UUID(), user: user1)
        
        XCTAssertEqual(updatedUser, nil)
    }
    
    func testUpdateUserDoesntChangeExistingLessonId() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        let user2 = User(email: "test2@kse.org.ua", passwordHash: "frfefw321", role: UserRole.admin)
        
        let _ = await repo.addUser(user1)
        let updatedUser = await repo.updateUser(id: user1.id, user: user2)
        
        XCTAssertEqual(updatedUser?.id, user1.id)
        XCTAssertEqual(updatedUser?.email, user2.email)
        XCTAssertEqual(updatedUser?.passwordHash, user2.passwordHash)
        XCTAssertEqual(updatedUser?.role, user2.role)
        
    }
    
    func testRemoveUserWhichDoesntExistReturnsNil() async {
        let repo = InMemoryUserRepository()
        
        let isDeleted = await repo.removeUser(id: UUID())
        
        XCTAssertEqual(isDeleted, false)
    }
    
    func testRemoveUser() async {
        let repo = InMemoryUserRepository()
        let user1 = User(email: "test1@kse.org.ua", passwordHash: "23432fdsgf", role: UserRole.student)
        
        let _ = await repo.addUser(user1)
        let isDeleted = await repo.removeUser(id: user1.id)
        let users = await repo.getAllUsers()
        
        XCTAssertEqual(isDeleted, true)
        XCTAssertEqual(users.count, 0)
    }
    
}
