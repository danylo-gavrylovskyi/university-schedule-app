import Foundation
public class ScheduleService : ScheduleServiceProtocol{
    private let userRepo: UserRepository
    private let lessonRepo: LessonRepository
    
    public init(userRepo: UserRepository, lessonRepo: LessonRepository){
        self.userRepo = userRepo
        self.lessonRepo = lessonRepo
    }
    
    public func getLessonsForUser(id: UUID) async -> [Lesson]{
        guard let user = await userRepo.getUserById(id) else {return []}
        
        let lessons  = await lessonRepo.getAllLessons()
        return lessons.filter{user.enrolledLessonIds.contains($0.id)}
    }
}
