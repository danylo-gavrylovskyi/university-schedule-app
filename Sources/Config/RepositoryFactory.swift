import Foundation

public final class RepositoryFactory {
    
    public static func createUserRepository() -> InMemoryUserRepository {
        let repo = InMemoryUserRepository()
        
        Task {
            for user in MockData.users {
                _ = await repo.addUser(user)
            }
        }
        
        return repo
    }
    
    public static func createLessonRepository() -> InMemoryLessonRepository {
        let repo = InMemoryLessonRepository()
        
        Task {
            for lesson in MockData.lessons {
                _ = await repo.addLesson(lesson)
            }
        }
        
        return repo
    }
}
