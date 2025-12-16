import Foundation

struct LessonSection {
    let date: Date
    var lessons: [Lesson]
}

final class LessonsViewModel: ObservableObject {
    
    @Published var sections: [LessonSection] = [
        LessonSection(date: Date(), lessons: [Lesson(subjectName: "Cloud Architecture", teacherName: "John Doe", classroom: "1.07", type: LessonType.lecture, format: LessonFormat.offline, startTime: Date(), endTime: Date().addingTimeInterval(1000)), Lesson(subjectName: "Java Development", teacherName: "John Doe", classroom: "1.16", type: LessonType.practice, format: LessonFormat.offline, startTime: Date(), endTime: Date() + 10)]), LessonSection(date: Date().addingTimeInterval(100000), lessons: [Lesson(subjectName: "Apple Platform", teacherName: "John Doe", classroom: "1.07", type: LessonType.lecture, format: LessonFormat.offline, startTime: Date(), endTime: Date().addingTimeInterval(1000)), Lesson(subjectName: "Java Development", teacherName: "John Doe", classroom: "1.16", type: LessonType.lecture, format: LessonFormat.offline, startTime: Date(), endTime: Date() + 10)])
    ] // its just mock data to test ui
    
    private func aggregateLessons(_ lessons: [Lesson]) {
        let grouped = Dictionary(grouping: lessons) { lesson in
            Calendar.current.startOfDay(for: lesson.startTime)
        }
        
        let sortedKeys = grouped.keys.sorted()
        
        self.sections = sortedKeys.map { date in
            let sortedLessons = grouped[date]?.sorted { $0.startTime < $1.startTime }
            return LessonSection(date: date, lessons: sortedLessons ?? [])
        }
    }
    
    func deleteLesson(section: Int, row: Int) {
        var updatedSections = sections
        updatedSections[section].lessons.remove(at: row)
        
        if updatedSections[section].lessons.isEmpty {
            updatedSections.remove(at: section)
        }
        
        self.sections = updatedSections
        
        // add delete this lesson logic
    }
    
}
