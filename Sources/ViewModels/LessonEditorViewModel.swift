import Foundation
import Combine

@MainActor
final class LessonEditorViewModel: ObservableObject {
    
    @Published var subjectName: String = ""
    @Published var teacherName: String = ""
    @Published var classroom: String = ""
    @Published var type: LessonType = .lecture
    @Published var format: LessonFormat = .offline
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date().addingTimeInterval(5400)
    
    @Published var isSaving = false
    @Published var errorMessage: String?
    
    private let scheduleService: ScheduleService
    private let lesson: Lesson?
    
    var isEditMode: Bool {
        lesson != nil
    }
    
    init(lesson: Lesson? = nil, scheduleService: ScheduleService) {
        self.lesson = lesson
        self.scheduleService = scheduleService
        
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
    
    func saveLesson() async -> Bool {
        isSaving = true
        errorMessage = nil
        
        let newLesson = Lesson(
            id: lesson?.id ?? UUID(),
            subjectName: subjectName,
            teacherName: teacherName,
            classroom: classroom,
            type: type,
            format: format,
            startTime: startTime,
            endTime: endTime
        )
        
        let result: Result<Lesson, ValidationError>
        
        if let existingLesson = lesson {
            result = await scheduleService.updateLesson(id: existingLesson.id, lesson: newLesson)
        } else {
            result = await scheduleService.addLesson(newLesson)
        }
        
        isSaving = false
        
        switch result {
        case .success:
            return true
        case .failure(let error):
            errorMessage = errorDescription(for: error)
            return false
        }
    }
    
    private func errorDescription(for error: ValidationError) -> String {
        switch error {
        case .emptySubjectName:
            return "Subject name cannot be empty"
        case .emptyTeacherName:
            return "Teacher name cannot be empty"
        case .emptyClassroom:
            return "Classroom cannot be empty"
        case .invalidTimeRange:
            return "End time must be after start time"
        }
    }
}
