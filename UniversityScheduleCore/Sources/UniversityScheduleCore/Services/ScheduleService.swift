import Foundation

public struct LessonSection {
    public let date: Date
    public var lessons: [Lesson]
    
    public init(date: Date, lessons: [Lesson]) {
        self.date = date
        self.lessons = lessons
    }
}

public protocol ScheduleServiceProtocol {
    func getAllLessons() async -> [LessonSection]
    func getLessonById(_ id: UUID) async -> Lesson?
    func addLesson(_ lesson: Lesson) async -> Result<Lesson, ValidationError>
    func updateLesson(id: UUID, lesson: Lesson) async -> Result<Lesson, ValidationError>
    func deleteLesson(id: UUID) async -> Bool
}

public final class ScheduleService: ScheduleServiceProtocol {
    
    private let lessonRepository: LessonRepository
    private let validationService: ValidationServiceProtocol
    
    public init(lessonRepository: LessonRepository, validationService: ValidationServiceProtocol) {
        self.lessonRepository = lessonRepository
        self.validationService = validationService
    }
    
    public func getAllLessons() async -> [LessonSection] {
        let lessons = await lessonRepository.getAllLessons()
        return aggregateLessons(lessons)
    }
    
    public func getLessonById(_ id: UUID) async -> Lesson? {
        return await lessonRepository.getLessonById(id)
    }
    
    public func addLesson(_ lesson: Lesson) async -> Result<Lesson, ValidationError> {
        switch validationService.validateLesson(lesson) {
        case .success:
            let addedLesson = await lessonRepository.addLesson(lesson)
            return .success(addedLesson)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func updateLesson(id: UUID, lesson: Lesson) async -> Result<Lesson, ValidationError> {
        switch validationService.validateLesson(lesson) {
        case .success:
            guard let updatedLesson = await lessonRepository.updateLesson(id: id, lesson: lesson) else {
                return .failure(.invalidTimeRange)
            }
            return .success(updatedLesson)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func deleteLesson(id: UUID) async -> Bool {
        return await lessonRepository.removeLesson(id: id)
    }
    
    private func aggregateLessons(_ lessons: [Lesson]) -> [LessonSection] {
        let grouped = Dictionary(grouping: lessons) { lesson in
            Calendar.current.startOfDay(for: lesson.startTime)
        }
        
        return grouped.keys.sorted().map { date in
            let sortedLessons = grouped[date]?.sorted { $0.startTime < $1.startTime } ?? []
            return LessonSection(date: date, lessons: sortedLessons)
        }
    }
}
