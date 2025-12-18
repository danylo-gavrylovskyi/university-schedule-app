import Foundation
struct TimeSlot : Sendable{
    let numOfLesson: Int
    let startTime: String
    let endTime: String
    
    static let standardSchedule: [TimeSlot] = [
        TimeSlot(numOfLesson: 1, startTime: "08:30", endTime: "09:50"),
        TimeSlot(numOfLesson: 2, startTime: "10:00", endTime: "11:20"),
        TimeSlot(numOfLesson: 3, startTime: "11:30", endTime: "12:50"),
        TimeSlot(numOfLesson: 4, startTime: "13:30", endTime: "14:50"),
        TimeSlot(numOfLesson: 5, startTime: "15:00", endTime: "16:20"),
        TimeSlot(numOfLesson: 6, startTime: "16:30", endTime: "17:50"),
        TimeSlot(numOfLesson: 7, startTime: "18:00", endTime: "19:20"),
        TimeSlot(numOfLesson: 8, startTime: "19:30", endTime: "20:50"),
        ]
}
