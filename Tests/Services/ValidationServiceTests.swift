import XCTest
@testable import university_schedule_app

final class ValidationServiceTests: XCTestCase {
    
    var validationService: ValidationService!
    
    override func setUp() {
        validationService = ValidationService()
    }
    
    override func tearDown() {
        validationService = nil
    }
    
    func testValidateLessonWithValidData() {
        let lesson = Lesson(
            subjectName: "Math",
            teacherName: "John Doe",
            classroom: "1.07",
            type: .lecture,
            format: .offline,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = validationService.validateLesson(lesson)
        
        if case .failure = result {
            XCTFail("Should succeed with valid data")
        }
    }
    
    func testValidateLessonWithEmptySubjectName() {
        let lesson = Lesson(
            subjectName: "",
            teacherName: "John Doe",
            classroom: "1.07",
            type: .lecture,
            format: .offline,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = validationService.validateLesson(lesson)
        
        if case .failure(let error) = result {
            XCTAssertEqual(error, .emptySubjectName)
        } else {
            XCTFail("Should fail with empty subject name")
        }
    }
    
    func testValidateLessonWithInvalidTimeRange() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(-3600)
        
        let lesson = Lesson(
            subjectName: "Math",
            teacherName: "John Doe",
            classroom: "1.07",
            type: .lecture,
            format: .offline,
            startTime: startTime,
            endTime: endTime
        )
        
        let result = validationService.validateLesson(lesson)
        
        if case .failure(let error) = result {
            XCTAssertEqual(error, .invalidTimeRange)
        } else {
            XCTFail("Should fail with invalid time range")
        }
    }
    
    func testValidateEmailWithValidEmail() {
        XCTAssertTrue(validationService.validateEmail("test@kse.org.ua"))
        XCTAssertTrue(validationService.validateEmail("user.name@example.com"))
    }
    
    func testValidateEmailWithInvalidEmail() {
        XCTAssertFalse(validationService.validateEmail("invalidemail"))
        XCTAssertFalse(validationService.validateEmail("@kse.org.ua"))
        XCTAssertFalse(validationService.validateEmail("test@"))
    }
}
