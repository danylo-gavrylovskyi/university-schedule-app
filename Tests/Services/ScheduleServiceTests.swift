import XCTest
@testable import university_schedule_app

final class ScheduleServiceTests: XCTestCase {
    
    var scheduleService: ScheduleService!
    var lessonRepository: InMemoryLessonRepository!
    var validationService: ValidationService!
    
    override func setUp() async throws {
        lessonRepository = InMemoryLessonRepository()
        validationService = ValidationService()
        scheduleService = ScheduleService(lessonRepository: lessonRepository, validationService: validationService)
        
        for lesson in MockData.lessons {
            _ = await lessonRepository.addLesson(lesson)
        }
    }
    
    override func tearDown() {
        scheduleService = nil
        lessonRepository = nil
        validationService = nil
    }
    
    func testGetAllLessonsReturnsGroupedAndSortedSections() async {
        let sections = await scheduleService.getAllLessons()
        
        XCTAssertGreaterThan(sections.count, 0)
        
        for section in sections {
            for i in 0..<section.lessons.count - 1 {
                XCTAssertLessThanOrEqual(section.lessons[i].startTime, section.lessons[i + 1].startTime)
            }
        }
    }
    
    func testGetLessonByIdReturnsCorrectLesson() async {
        let lessonId = MockData.lessons[0].id
        
        let lesson = await scheduleService.getLessonById(lessonId)
        
        XCTAssertNotNil(lesson)
        XCTAssertEqual(lesson?.id, lessonId)
    }
    
    func testAddLessonWithValidData() async {
        let newLesson = Lesson(
            subjectName: "Physics",
            teacherName: "Dr. Smith",
            classroom: "3.01",
            type: .lecture,
            format: .offline,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = await scheduleService.addLesson(newLesson)
        
        if case .failure = result {
            XCTFail("Should succeed with valid data")
        }
    }
    
    func testAddLessonWithInvalidDataFails() async {
        let invalidLesson = Lesson(
            subjectName: "",
            teacherName: "Dr. Smith",
            classroom: "3.01",
            type: .lecture,
            format: .offline,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = await scheduleService.addLesson(invalidLesson)
        
        if case .failure(let error) = result {
            XCTAssertEqual(error, .emptySubjectName)
        } else {
            XCTFail("Should fail with invalid data")
        }
    }
    
    func testUpdateLessonWithValidData() async {
        let lessonId = MockData.lessons[0].id
        let updatedLesson = Lesson(
            subjectName: "Updated Subject",
            teacherName: "Updated Teacher",
            classroom: "2.02",
            type: .practice,
            format: .online,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = await scheduleService.updateLesson(id: lessonId, lesson: updatedLesson)
        
        if case .success(let lesson) = result {
            XCTAssertEqual(lesson.id, lessonId)
            XCTAssertEqual(lesson.subjectName, "Updated Subject")
        } else {
            XCTFail("Should succeed with valid data")
        }
    }
    
    func testUpdateLessonWithInvalidDataFails() async {
        let lessonId = MockData.lessons[0].id
        let invalidLesson = Lesson(
            subjectName: "Valid",
            teacherName: "",
            classroom: "2.02",
            type: .practice,
            format: .online,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        let result = await scheduleService.updateLesson(id: lessonId, lesson: invalidLesson)
        
        if case .failure(let error) = result {
            XCTAssertEqual(error, .emptyTeacherName)
        } else {
            XCTFail("Should fail with invalid data")
        }
    }
    
    func testDeleteLessonSucceeds() async {
        let lessonId = MockData.lessons[0].id
        
        let deleted = await scheduleService.deleteLesson(id: lessonId)
        
        XCTAssertTrue(deleted)
        
        let lesson = await scheduleService.getLessonById(lessonId)
        XCTAssertNil(lesson)
    }
    
    func testDeleteNonExistentLessonFails() async {
        let deleted = await scheduleService.deleteLesson(id: UUID())
        
        XCTAssertFalse(deleted)
    }
}
