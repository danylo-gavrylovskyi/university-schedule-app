import XCTest
@testable import university_schedule_app

final class StudentScheduleServiceTests: XCTestCase {
    
    var studentScheduleService: StudentScheduleService!
    var lessonRepository: InMemoryLessonRepository!
    var testUserId: UUID!
    
    override func setUp() async throws {
        lessonRepository = InMemoryLessonRepository()
        studentScheduleService = StudentScheduleService(lessonRepository: lessonRepository)
        testUserId = MockData.studentUser.id
        
        for lesson in MockData.lessons {
            _ = await lessonRepository.addLesson(lesson)
        }
    }
    
    override func tearDown() {
        studentScheduleService = nil
        lessonRepository = nil
        testUserId = nil
    }
    
    func testGetMyLessonsInitiallyEmpty() async {
        let lessons = await studentScheduleService.getMyLessons(userId: testUserId)
        
        XCTAssertTrue(lessons.isEmpty)
    }
    
    func testAddToMyScheduleSucceeds() async {
        let lessonId = MockData.lessons[0].id
        
        let success = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: lessonId)
        
        XCTAssertTrue(success)
        
        let lessons = await studentScheduleService.getMyLessons(userId: testUserId)
        XCTAssertEqual(lessons.count, 1)
        XCTAssertEqual(lessons.first?.id, lessonId)
    }
    
    func testAddToMyScheduleWithNonExistentLessonFails() async {
        let success = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: UUID())
        
        XCTAssertFalse(success)
    }
    
    func testAddSameLessonTwiceDoesNotDuplicate() async {
        let lessonId = MockData.lessons[0].id
        
        _ = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: lessonId)
        _ = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: lessonId)
        
        let lessons = await studentScheduleService.getMyLessons(userId: testUserId)
        
        XCTAssertEqual(lessons.count, 1)
    }
    
    func testRemoveFromMyScheduleSucceeds() async {
        let lessonId = MockData.lessons[0].id
        
        _ = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: lessonId)
        let removed = await studentScheduleService.removeFromMySchedule(userId: testUserId, lessonId: lessonId)
        
        XCTAssertTrue(removed)
        
        let lessons = await studentScheduleService.getMyLessons(userId: testUserId)
        XCTAssertTrue(lessons.isEmpty)
    }
    
    func testIsLessonInMySchedule() async {
        let lessonId = MockData.lessons[0].id
        
        var isPresent = await studentScheduleService.isLessonInMySchedule(userId: testUserId, lessonId: lessonId)
        XCTAssertFalse(isPresent)
        
        _ = await studentScheduleService.addToMySchedule(userId: testUserId, lessonId: lessonId)
        
        isPresent = await studentScheduleService.isLessonInMySchedule(userId: testUserId, lessonId: lessonId)
        XCTAssertTrue(isPresent)
    }
    
    func testDifferentUsersHaveSeparateSchedules() async {
        let userId1 = testUserId!
        let userId2 = UUID()
        let lessonId1 = MockData.lessons[0].id
        let lessonId2 = MockData.lessons[1].id
        
        _ = await studentScheduleService.addToMySchedule(userId: userId1, lessonId: lessonId1)
        _ = await studentScheduleService.addToMySchedule(userId: userId2, lessonId: lessonId2)
        
        let lessons1 = await studentScheduleService.getMyLessons(userId: userId1)
        let lessons2 = await studentScheduleService.getMyLessons(userId: userId2)
        
        XCTAssertEqual(lessons1.count, 1)
        XCTAssertEqual(lessons2.count, 1)
        XCTAssertNotEqual(lessons1.first?.id, lessons2.first?.id)
    }
}
