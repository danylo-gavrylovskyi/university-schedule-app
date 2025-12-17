import Foundation

public actor InMemoryUserRepository: UserRepository {
    
    private var users: [User] = []
    
    
    //DELETE THIS BLOCK IN FUTURE START
    
    public func seedUser(with lessonIds: Set<UUID>) {
            let user = User(
                id: testUserId,
                email: "student@university.com",
                passwordHash: "secure_pass",
                role: .student,
                enrolledLessonIds:lessonIds
            )
            users.append(user)
        }
    //DELETE THIS BLOCK IN FUTURE END
    
    
    public func getAllUsers() async -> [User] {
        users
    }
    
    public func getUserById(_ id: UUID) async -> User? {
        users.first(where: { $0.id == id })
    }
    
    public func getUserByEmail(_ email: String) async -> User? {
        users.first(where: { $0.email == email })
    }
    
    public func existsUserByEmail(_ email: String) async -> Bool {
        users.contains(where: { $0.email.caseInsensitiveCompare(email) == .orderedSame })
    }
    
    public func addUser(_ user: User) async -> User {
        users.append(user)
        return user
    }
    
    public func updateUser(id: UUID, user: User) async -> User? {
        guard let idx = users.firstIndex(where: { $0.id == id }) else { return nil }
        
        let updatedUser = User(
            id: id,
            email: user.email,
            passwordHash: user.passwordHash,
            role: user.role
        )
        
        users[idx] = updatedUser
        
        return updatedUser
    }
    
    public func removeUser(id: UUID) async -> Bool {
        guard let idx = users.firstIndex(where: { $0.id == id }) else { return false }
        
        users.remove(at: idx)
        return true
    }
    
    
}
