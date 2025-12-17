import Foundation
public protocol ScheduleServiceProtocol {
    func getLessonsForUser(id: UUID) async -> [Lesson]
}
