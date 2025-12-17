import Foundation

public final class RepositoryFactory {
    
    public static func createUserRepository() async -> InMemoryUserRepository {
        let repo = InMemoryUserRepository()
        
        for user in MockData.users {
            _ = await repo.addUser(user)
        }
        
        return repo
    }
    
    public static func createLessonRepository() async -> InMemoryLessonRepository {
        let repo = InMemoryLessonRepository()
        
        for lesson in MockData.lessons {
            _ = await repo.addLesson(lesson)
        }
        
        return repo
    }
}
