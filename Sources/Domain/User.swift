import Foundation

public struct User: Equatable {
    public let id: UUID
    public let email: String
    public let passwordHash: String
    public let role: UserRole
    public var enrolledLessonIds: Set<UUID>
    
    init(id: UUID = UUID(), email: String, passwordHash: String, role: UserRole, enrolledLessonIds: Set<UUID> = []) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.role = role
        self.enrolledLessonIds = enrolledLessonIds
    }
}
