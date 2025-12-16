import Foundation

public protocol LessonsRepository {
    
    func getAllLessons() async -> [Lesson]
    
    func getLessonById(id: UUID) async -> Lesson?
    
    func getLessonsByTimeSpan(startTime: Date, endTime: Date) async -> [Lesson]
    
    func addLesson(_ lesson: Lesson) async -> Lesson
    
    func updateLesson(id: UUID, lesson: Lesson) async -> Lesson?
    
    func removeLesson(id: UUID) async -> Bool
    
}
