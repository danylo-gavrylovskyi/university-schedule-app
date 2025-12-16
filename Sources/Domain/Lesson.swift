import Foundation

public struct Lesson: Equatable {
    public let id: UUID
    public let subjectName: String
    public let teacherName: String
    public let classroom: String
    public let type: LessonType
    public let format: LessonFormat
    public let startTime: Date
    public let endTime: Date
    
    init(id: UUID = UUID(), subjectName: String, teacherName: String, classroom: String, type: LessonType, format: LessonFormat, startTime: Date, endTime: Date) {
        self.id = id
        self.subjectName = subjectName
        self.teacherName = teacherName
        self.classroom = classroom
        self.type = type
        self.format = format
        self.startTime = startTime
        self.endTime = endTime
    }
}
