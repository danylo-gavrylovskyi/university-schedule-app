import Foundation

public struct MockData {
    
    public static let adminUser = User(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        email: "admin@kse.org.ua",
        passwordHash: "admin123",
        role: .admin
    )
    
    public static let studentUser = User(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        email: "student@kse.org.ua",
        passwordHash: "student123",
        role: .student
    )
    
    public static let users: [User] = [adminUser, studentUser]
    
    public static let lessons: [Lesson] = {
        let now = Date()
        let calendar = Calendar.current
        
        let monday9AM = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let monday11AM = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: now)!
        let monday2PM = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!
        let monday4PM = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!
        
        let tuesday10AM = calendar.date(byAdding: .day, value: 1, to: monday9AM)!
        let tuesday12PM = calendar.date(byAdding: .day, value: 1, to: monday11AM)!
        
        return [
            Lesson(
                id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
                subjectName: "Cloud Architecture", teacherName: "John Doe",
                classroom: "1.07", type: .lecture,
                format: .offline, startTime: monday9AM, endTime: monday11AM
            ),
            Lesson(
                id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
                subjectName: "Java Development", teacherName: "Jane Smith",
                classroom: "1.16", type: .practice,
                format: .online, startTime: monday2PM, endTime: monday4PM
            ),
            Lesson(
                id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!,
                subjectName: "Apple Platform", teacherName: "Mike Johnson",
                classroom: "2.05", type: .lecture,
                format: .offline, startTime: tuesday10AM, endTime: tuesday12PM
            )
        ]
    }()
}
