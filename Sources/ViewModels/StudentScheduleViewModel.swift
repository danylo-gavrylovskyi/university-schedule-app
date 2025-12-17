import Foundation
import Combine

@MainActor
final class StudentScheduleViewModel: ObservableObject {
    
    @Published var sections: [LessonSection] = []
    @Published var myLessonIds: Set<UUID> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let scheduleService: ScheduleService
    private let studentScheduleService: StudentScheduleService
    private let userId: UUID
    
    init(scheduleService: ScheduleService, studentScheduleService: StudentScheduleService, userId: UUID) {
        self.scheduleService = scheduleService
        self.studentScheduleService = studentScheduleService
        self.userId = userId
    }
    
    func loadAllLessons() async {
        isLoading = true
        errorMessage = nil
        
        let sections = await scheduleService.getAllLessons()
        self.sections = sections
        
        isLoading = false
    }
    
    func loadMyLessons() async {
        let myLessons = await studentScheduleService.getMyLessons(userId: userId)
        self.myLessonIds = Set(myLessons.map { $0.id })
    }
    
    func addToMySchedule(lessonId: UUID) async {
        let success = await studentScheduleService.addToMySchedule(userId: userId, lessonId: lessonId)
        
        if success {
            myLessonIds.insert(lessonId)
        } else {
            errorMessage = "Failed to add lesson to schedule"
        }
    }
    
    func removeFromMySchedule(lessonId: UUID) async {
        let success = await studentScheduleService.removeFromMySchedule(userId: userId, lessonId: lessonId)
        
        if success {
            myLessonIds.remove(lessonId)
        } else {
            errorMessage = "Failed to remove lesson from schedule"
        }
    }
    
    func isInMySchedule(lessonId: UUID) -> Bool {
        return myLessonIds.contains(lessonId)
    }
    
    func getMyScheduleSections() async -> [LessonSection] {
        let myLessons = await studentScheduleService.getMyLessons(userId: userId)
        
        let grouped = Dictionary(grouping: myLessons) { lesson in
            Calendar.current.startOfDay(for: lesson.startTime)
        }
        
        return grouped.keys.sorted().map { date in
            let sortedLessons = grouped[date]?.sorted { $0.startTime < $1.startTime } ?? []
            return LessonSection(date: date, lessons: sortedLessons)
        }
    }
}
