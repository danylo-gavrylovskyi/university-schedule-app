import Foundation

public protocol UserRepository {
    
    func getAllUsers() async -> [User]
    
    func getUserById(_ id: UUID) async -> User?
    
    func getUserByEmail(_ email: String) async -> User?
    
    func existsUserByEmail(_ email: String) async -> Bool
    
    func addUser(_ user: User) async -> User
    
    func updateUser(id: UUID, user: User) async -> User?
    
    func removeUser(id: UUID) async -> Bool
    
}
