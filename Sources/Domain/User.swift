import Foundation

//DELETE START
public let testUserId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!
//DELETE END

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
