import Foundation

public protocol StudentScheduleServiceProtocol {
    func getMyLessons(userId: UUID) async -> [Lesson]
    func addToMySchedule(userId: UUID, lessonId: UUID) async -> Bool
    func removeFromMySchedule(userId: UUID, lessonId: UUID) async -> Bool
    func isLessonInMySchedule(userId: UUID, lessonId: UUID) async -> Bool
}

public actor StudentScheduleService: StudentScheduleServiceProtocol {
    
    private let lessonRepository: LessonRepository
    private var studentSchedules: [UUID: Set<UUID>] = [:]
    
    public init(lessonRepository: LessonRepository) {
        self.lessonRepository = lessonRepository
    }
    
    public func getMyLessons(userId: UUID) async -> [Lesson] {
        guard let lessonIds = studentSchedules[userId] else {
            return []
        }
        
        let allLessons = await lessonRepository.getAllLessons()
        return allLessons.filter { lessonIds.contains($0.id) }
    }
    
    public func addToMySchedule(userId: UUID, lessonId: UUID) async -> Bool {
        guard await lessonRepository.getLessonById(lessonId) != nil else {
            return false
        }
        
        if studentSchedules[userId] == nil {
            studentSchedules[userId] = []
        }
        
        studentSchedules[userId]?.insert(lessonId)
        return true
    }
    
    public func removeFromMySchedule(userId: UUID, lessonId: UUID) async -> Bool {
        guard studentSchedules[userId] != nil else {
            return false
        }
        
        studentSchedules[userId]?.remove(lessonId)
        return true
    }
    
    public func isLessonInMySchedule(userId: UUID, lessonId: UUID) async -> Bool {
        return studentSchedules[userId]?.contains(lessonId) ?? false
    }
}
