import XCTest
@testable import university_schedule_app

final class LessonRepositoryTests: XCTestCase {
    
    func testGetAllLessons() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let _ = await repo.addLesson(lesson2)
        let lessons = await repo.getAllLessons()
        
        XCTAssertEqual(lessons.count, 2)
        XCTAssertEqual(lessons.first?.id, lesson1.id)
        XCTAssertEqual(lessons.last?.id, lesson2.id)
    }
    
    func testGetLessonById() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let _ = await repo.addLesson(lesson2)
        let lesson = await repo.getLessonById(lesson2.id)
        
        XCTAssertNotEqual(lesson, nil)
        XCTAssertEqual(lesson?.id, lesson2.id)
        XCTAssertEqual(lesson?.subjectName, lesson2.subjectName)
    }
    
    func testGetLessonByIdWithWrongIdReturnsNil() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let _ = await repo.addLesson(lesson2)
        let lesson = await repo.getLessonById(UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)
        
        XCTAssertEqual(lesson, nil)
    }
    
    func testGetLessonsByTimeSpanWithCorrectDates() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date() + 2, endTime: Date() + 4)
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date() + 6, endTime: Date() + 8)
        
        let _ = await repo.addLesson(lesson1)
        let _ = await repo.addLesson(lesson2)
        let lessons = await repo.getLessonsByTimeSpan(startTime: lesson1.startTime, endTime: lesson1.endTime)
        
        XCTAssertEqual(lessons.count, 1)
        XCTAssertEqual(lessons.first?.id, lesson1.id)
    }
    
    func testGetLessonsByTimeSpanWithIncorrectDatesReturnEmptyArray() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date() + 2, endTime: Date() + 4)
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date() + 6, endTime: Date() + 8)
        
        let _ = await repo.addLesson(lesson1)
        let _ = await repo.addLesson(lesson2)
        let lessons = await repo.getLessonsByTimeSpan(startTime: lesson1.endTime, endTime: lesson1.startTime)
        
        XCTAssertEqual(lessons.count, 0)
    }
    
    func testAddLesson() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let lessons = await repo.getAllLessons()
        
        XCTAssertEqual(lessons.count, 1)
        XCTAssertEqual(lessons.first?.id, lesson1.id)
        XCTAssertEqual(lessons.first?.subjectName, lesson1.subjectName)
        XCTAssertEqual(lessons.first?.teacherName, lesson1.teacherName)
        XCTAssertEqual(lessons.first?.classroom, lesson1.classroom)
        XCTAssertEqual(lessons.first?.startTime, lesson1.startTime)
        XCTAssertEqual(lessons.first?.endTime, lesson1.endTime)
    }
    
    func testUpdateLessonWhichDoesntExistReturnsNil() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        
        let updatedLesson = await repo.updateLesson(id: UUID(), lesson: lesson1)
        
        XCTAssertEqual(updatedLesson, nil)
    }
    
    func testUpdateLessonDoesntChangeExistingLessonId() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        let lesson2 = Lesson(subjectName: "test2", teacherName: "test2", classroom: "test2", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let updatedLesson = await repo.updateLesson(id: lesson1.id, lesson: lesson2)
        
        XCTAssertEqual(updatedLesson?.id, lesson1.id)
        XCTAssertEqual(updatedLesson?.subjectName, lesson2.subjectName)
        XCTAssertEqual(updatedLesson?.teacherName, lesson2.teacherName)
        XCTAssertEqual(updatedLesson?.classroom, lesson2.classroom)
        XCTAssertEqual(updatedLesson?.startTime, lesson2.startTime)
        XCTAssertEqual(updatedLesson?.endTime, lesson2.endTime)
        
    }
    
    func testRemoveLessonWhichDoesntExistReturnsNil() async {
        let repo = InMemoryLessonRepository()
        
        let isDeleted = await repo.removeLesson(id: UUID())
        
        XCTAssertEqual(isDeleted, false)
    }
    
    func testRemoveLesson() async {
        let repo = InMemoryLessonRepository()
        let lesson1 = Lesson(subjectName: "test1", teacherName: "test1", classroom: "test1", startTime: Date(), endTime: Date())
        
        let _ = await repo.addLesson(lesson1)
        let isDeleted = await repo.removeLesson(id: lesson1.id)
        let lessons = await repo.getAllLessons()
        
        XCTAssertEqual(isDeleted, true)
        XCTAssertEqual(lessons.count, 0)
    }
    
}
