import UIKit

class LessonDetailViewController : UIViewController{
    private let lesson: Lesson
    private let timeSlot: TimeSlot
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let okButton = UIButton(type: .system)
    
    init(lesson: Lesson, slot :TimeSlot){
        self.lesson = lesson
        self.timeSlot = slot
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init? (coder: NSCoder) {fatalError()}
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setUpUI()
        setValue()
    }
    
    private func setUpUI(){
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        let whenSection  =  createSection(
            title: "WHEN:",
            rows: [
                createRow(icon: "clock", text: "\(timeSlot.startTime) - \(timeSlot.endTime)"),
                createRow(icon: "calendar", text: formatDate(lesson.startTime)),
                createRow(icon: "number", text: "Period \(timeSlot.numOfLesson)")
        ])
        
        let whereSection  =  createSection(
            title: "WHERE:",
            rows: [
                createRow(icon: "mappin.and.ellipse", text: lesson.classroom)
        ])
        
        let teacherSection  =  createSection(
            title: "TEACHER:",
            rows: [
                createRow(icon: "person", text: lesson.teacherName)
        ])
        
        
        okButton.setTitle("OK", for: .normal)
        okButton.backgroundColor = .systemBlue
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.layer.cornerRadius = 20
        okButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        okButton.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
        
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel, whenSection, whereSection, teacherSection])
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .leading
        contentStackView.setCustomSpacing(10, after: titleLabel)
        
        containerView.addSubview(contentStackView)
        containerView.addSubview(okButton)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant:40),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant : 24),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            okButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 24),
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            okButton.widthAnchor.constraint(equalToConstant: 80),
            okButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        [whenSection,whereSection,teacherSection].forEach{
            $0.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        }
    }
    
    private func setValue(){
        titleLabel.text = lesson.subjectName
    }
    
    @objc private func didTapOkButton(){
        dismiss(animated: true)
    }
    
    private func createSection(title: String, rows : [UIView]) -> UIView{
        let container = UIView()
        
        container.backgroundColor = UIColor(white:0.95, alpha: 1)
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.blue.cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 11, weight: .medium)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel] + rows)
        stackView.axis = .vertical
        stackView.spacing = 10
        
        container.addSubview(titleLabel)
        container.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func createRow(icon:String, text: String) -> UIView{
         let view = UIView()
         let imageView = UIImageView()
        imageView.image = UIImage(systemName: icon)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant:12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    private func formatDate(_ date: Date) ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d yyyy"
        return formatter.string(from: date)
    }
}
