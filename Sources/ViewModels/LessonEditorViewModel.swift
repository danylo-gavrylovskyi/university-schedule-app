import Foundation
import Combine

final class LessonEditorViewModel: ObservableObject {
    
    @Published var subjectName: String = ""
    @Published var teacherName: String = ""
    @Published var classroom: String = ""
    @Published var type: LessonType = .lecture
    @Published var format: LessonFormat = .offline
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    
    private let lesson: Lesson?
    
    var title: String { lesson != nil ? "Edit Lesson" : "Add Lesson" }
    
    init(lesson: Lesson? = nil) {
        self.lesson = lesson
        
        if let lesson = lesson {
            self.subjectName = lesson.subjectName
            self.teacherName = lesson.teacherName
            self.classroom = lesson.classroom
            self.type = lesson.type
            self.format = lesson.format
            self.startTime = lesson.startTime
            self.endTime = lesson.endTime
        }
    }
    
    func saveLesson() {
        // add save logic
    }
    
}
