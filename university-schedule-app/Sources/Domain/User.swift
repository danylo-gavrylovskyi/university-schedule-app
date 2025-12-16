import Foundation

public struct User {
    public let id: UUID
    public let email: String
    public let passwordHash: String
    public let role: UserRole
    
    init(id: UUID = UUID(), email: String, passwordHash: String, role: UserRole) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.role = role
    }
}
