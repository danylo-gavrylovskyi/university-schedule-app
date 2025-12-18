import Foundation

public enum ValidationError: Error, Equatable {
    case emptySubjectName
    case emptyTeacherName
    case emptyClassroom
    case invalidTimeRange
}

public protocol ValidationServiceProtocol {
    func validateLesson(_ lesson: Lesson) -> Result<Void, ValidationError>
    func validateEmail(_ email: String) -> Bool
}

public final class ValidationService: ValidationServiceProtocol {
    
    public init() {}
    
    public func validateLesson(_ lesson: Lesson) -> Result<Void, ValidationError> {
        if lesson.subjectName.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(.emptySubjectName)
        }
        
        if lesson.teacherName.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(.emptyTeacherName)
        }
        
        if lesson.classroom.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(.emptyClassroom)
        }
        
        if lesson.endTime <= lesson.startTime {
            return .failure(.invalidTimeRange)
        }
        
        return .success(())
    }
    
    public func validateEmail(_ email: String) -> Bool {
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(email.startIndex..., in: email)
        return regex.firstMatch(in: email, range: range) != nil
    }
}
