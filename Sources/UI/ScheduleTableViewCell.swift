import UIKit

class ScheduleTableViewCell: UITableViewCell{
    
    private let cardContainer = UIView()
    private let leftStripe = UIView()
    private let timeLabel = UILabel()
    private let subjectLabel = UILabel()
    private let teacherLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    };
    
    private func setUpUI(){
        
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 10
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.08
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 4
        
        leftStripe.layer.cornerRadius = 2
        
        [cardContainer, leftStripe,timeLabel,subjectLabel,teacherLabel,locationLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(leftStripe)
        cardContainer.addSubview(timeLabel)
        cardContainer.addSubview(subjectLabel)
        cardContainer.addSubview(teacherLabel)
        cardContainer.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            leftStripe.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant:0),
            leftStripe.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant:15),
            leftStripe.widthAnchor.constraint(equalToConstant: 4),
            leftStripe.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -15),
            
            subjectLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            subjectLabel.leadingAnchor.constraint(equalTo: leftStripe.trailingAnchor, constant: 12),
            subjectLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            
            teacherLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 4),
            teacherLabel.leadingAnchor.constraint(equalTo:subjectLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: teacherLabel.bottomAnchor,constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: subjectLabel.leadingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: subjectLabel.leadingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -12)
            
        ])
        
        subjectLabel.font = .systemFont(ofSize: 16, weight: .bold)
        teacherLabel.font = .systemFont(ofSize: 14, weight: .regular)
        teacherLabel.textColor = .secondaryLabel
 
        
        
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        locationLabel.textColor = .secondaryLabel
        
        
        timeLabel.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .systemBlue
            
    }
        
        
    
    
        
    public func setValue(with lesson: Lesson, color: UIColor){
        subjectLabel.text = lesson.subjectName
        teacherLabel.text = lesson.teacherName
        locationLabel.text = lesson.classroom
        leftStripe.backgroundColor = color
            
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = "\(formatter.string(from: lesson.startTime)) - \(formatter.string(from: lesson.endTime))"
    }
        
}
    

