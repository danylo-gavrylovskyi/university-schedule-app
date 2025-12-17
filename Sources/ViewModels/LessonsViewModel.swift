import Foundation
import Combine

@MainActor
final class LessonsViewModel: ObservableObject {
    
    @Published var sections: [LessonSection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let scheduleService: ScheduleService
    
    init(scheduleService: ScheduleService) {
        self.scheduleService = scheduleService
    }
    
    func loadLessons() async {
        isLoading = true
        errorMessage = nil
        
        let sections = await scheduleService.getAllLessons()
        
        self.sections = sections
        isLoading = false
    }
    
    func deleteLesson(section: Int, row: Int) async {
        guard section < sections.count, row < sections[section].lessons.count else { return }
        
        let lessonId = sections[section].lessons[row].id
        
        let deleted = await scheduleService.deleteLesson(id: lessonId)
        
        if deleted {
            await loadLessons()
        } else {
            errorMessage = "Failed to delete lesson"
        }
    }
}
