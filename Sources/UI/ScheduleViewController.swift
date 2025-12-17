import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarDelegate{
    private let calendarView = CalendarHeaderView()
    private let tableView = UITableView()
    
    private var allLessons: [Lesson] = []
    private var lessonsByDate : [Lesson] = []
    
    private let timeSlots = TimeSlot.standardSchedule
    private var selectedDate: Date = Date()
    
    private let scheduleService: ScheduleServiceProtocol
    private let currentUserId: UUID
    
    init(service: ScheduleServiceProtocol, userId: UUID){
        self.scheduleService = service
        self.currentUserId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {fatalError()}
    
    override func viewDidLoad(){
        super.viewDidLoad( )
        view.backgroundColor = UIColor(white: 0.98, alpha : 1.0)
        setUpUI()
        loadUserLessons()
    }
    
    private func setUpUI(){
        
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TimelineTableViewCell.self, forCellReuseIdentifier: "TimelineCell")
        
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 150),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
            
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
        
    }
    
    private func loadUserLessons() {
        Task {
            let userLessons = await scheduleService.getLessonsForUser(id: currentUserId)
            
            await MainActor.run {
                self.allLessons = userLessons
                self.filterLessonsByDate(for: self.selectedDate)
                self.calendarView.updateMonthLabel(for : self.selectedDate)
            }
        }
    }
    
    private func filterLessonsByDate(for date: Date) {
        let calendar = Calendar.current
        self.lessonsByDate = allLessons.filter{ lesson in calendar.isDate(lesson.startTime, inSameDayAs: date)}
        self.tableView.reloadData()
    }
    
    //delegate
    func didSelectDate(_ date: Date) {
        self.selectedDate = date
        filterLessonsByDate(for:date)
        calendarView.updateMonthLabel(for:date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for : indexPath) as! TimelineTableViewCell
        
        let slot = timeSlots[indexPath.row]
        let matchingLesson = lessonsByDate.first{lesson in return isLesson(lesson, inSlot:slot)}
        
        timelineCell.setValue(slot: slot, lesson: matchingLesson)
        return timelineCell
    }
    
    func tableView( _ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimeSlot = timeSlots[indexPath.row]
        
        if let existingLesson = lessonsByDate.first(where: { isLesson($0, inSlot: selectedTimeSlot) }) {
            let detailVC = LessonDetailViewController(lesson: existingLesson, slot: selectedTimeSlot)
            present(detailVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func isLesson(_ lesson: Lesson, inSlot slot: TimeSlot) -> Bool {
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute], from: lesson.startTime)
        
        guard let lessonHour = components.hour, let lessonMinute = components.minute else {return false}
        
        let slotHourMinutes = slot.startTime.split(separator: ":").map{Int($0)}
        guard slotHourMinutes.count == 2, let slotHour = slotHourMinutes[0] , let slotMinute = slotHourMinutes[1] else {return false}
        
        return lessonHour == slotHour && lessonMinute == slotMinute
    }
}
    

