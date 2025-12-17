import Foundation

public actor InMemoryLessonRepository: LessonRepository {
    
    private var lessons: [Lesson] = []
    
    //DELETE THIS BLOCK IN FUTURE START
    public init() {
            let titles = [
                "Design Engineering",
                "UI/UX Interface Design",
                "Art History",
                "Mobile Development"
            ]
            
            let startHours   = [8,  10, 11, 13]
            let startMinutes = [30, 0,  30, 30]
            
            let endHours     = [9,  11, 12, 14]
            let endMinutes   = [50, 20, 50, 50]
            
            for i in 0..<4 {
                let start = Calendar.current.date(
                    bySettingHour: startHours[i],
                    minute: startMinutes[i],
                    second: 0,
                    of: Date()
                )!
                
                let end = Calendar.current.date(
                    bySettingHour: endHours[i],
                    minute: endMinutes[i],
                    second: 0,
                    of: Date()
                )!
                
                let lesson = Lesson(
                    id: UUID(),
                    subjectName: titles[i],
                    teacherName: "Dr. Alex Abakumov",
                    classroom: "Room 10\(i)A",
                    startTime: start,
                    endTime: end
                )
                lessons.append(lesson)
            }
        }
    //DELETE THIS BLOCK IN FUTURE END
    
    
    
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
