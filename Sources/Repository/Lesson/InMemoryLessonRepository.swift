import Foundation

public actor InMemoryLessonRepository: LessonRepository {
    
    private var lessons: [Lesson] = []
    
    public func getAllLessons() async -> [Lesson] {
        lessons
    }
    
    public func getLessonById(_ id: UUID) async -> Lesson? {
        lessons.first(where: { $0.id == id })
    }
    
    public func getLessonsByTimeSpan(startTime: Date, endTime: Date) async -> [Lesson] {
        guard endTime > startTime else { return [] }
        
        return lessons.filter({ $0.startTime >= startTime && $0.endTime <= endTime })
    }
    
    public func addLesson(_ lesson: Lesson) async -> Lesson {
        lessons.append(lesson)
        return lesson
    }
    
    public func updateLesson(id: UUID, lesson: Lesson) async -> Lesson? {
        guard let idx = lessons.firstIndex(where: { $0.id == id }) else { return nil }
        
        let updatedLesson = Lesson(
            id: id,
            subjectName: lesson.subjectName,
            teacherName: lesson.teacherName,
            classroom: lesson.classroom,
            type: lesson.type,
            format: lesson.format,
            startTime: lesson.startTime,
            endTime: lesson.endTime
        )
        
        lessons[idx] = updatedLesson
        
        return updatedLesson
    }
    
    public func removeLesson(id: UUID) async -> Bool {
        guard let idx = lessons.firstIndex(where: { $0.id == id }) else { return false }
        
        lessons.remove(at: idx)
        return true
    }
    
    
}
