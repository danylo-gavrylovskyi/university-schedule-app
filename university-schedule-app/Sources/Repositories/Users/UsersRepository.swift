import Foundation

public protocol UsersRepository {
    
    func getAllUsers() async -> [User]
    
    func getUserById(id: UUID) async -> User?
    
    func getUserByEmail(email: String) async -> User?
    
    func existsByEmail(email: String) async -> Bool
    
    func addUser(_ user: User) async -> User
    
    func updateUser(id: UUID, user: User) async -> User?
    
    func removeUser(id: UUID) async -> Bool
    
}
