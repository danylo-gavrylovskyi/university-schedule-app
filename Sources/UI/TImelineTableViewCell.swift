import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    private let timeStack = UIStackView()
    private let startLabel = UILabel()
    private let endLabel = UILabel()
    private let verticalLine = UIView()
    private let lessonSpace = UIView()
    private let numberLessonLabel =  UILabel()
        
    
    private let cardContainer = UIView()
    private let leftStripe = UIView()
    private let subjectLabel = UILabel()
    private let teacherLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init? (coder: NSCoder) {fatalError()}
    
    
    private func setUpUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        startLabel.font = .systemFont(ofSize: 12, weight: .medium)
        startLabel.textColor = .gray
        startLabel.textAlignment = .center
        endLabel.font = .systemFont(ofSize: 12, weight: .medium)
        endLabel.textColor = .gray
        endLabel.textAlignment = .center
        
        verticalLine.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        lessonSpace.backgroundColor = .white
        lessonSpace.layer.borderWidth = 1
        lessonSpace.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        lessonSpace.layer.cornerRadius = 10
        
        numberLessonLabel.font = .systemFont(ofSize: 12, weight: .bold)
        numberLessonLabel.textColor = .black
        lessonSpace.addSubview(numberLessonLabel)
        
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 12
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.05
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainer.layer.shadowRadius = 6
        
        leftStripe.layer.cornerRadius = 2
        
        subjectLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        teacherLabel.font = .systemFont(ofSize: 12, weight: .regular)
        teacherLabel.textColor = .secondaryLabel
        teacherLabel.numberOfLines = 2
        
        locationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        locationLabel.textColor = .secondaryLabel
        
        contentView.addSubview(startLabel)
        contentView.addSubview(endLabel)
        contentView.addSubview(verticalLine)
        contentView.addSubview(lessonSpace)
        contentView.addSubview(cardContainer)
        
        cardContainer.addSubview(leftStripe)
        cardContainer.addSubview(subjectLabel)
        cardContainer.addSubview(teacherLabel)
        cardContainer.addSubview(locationLabel)
        
        [startLabel, endLabel, verticalLine, lessonSpace, cardContainer, leftStripe,subjectLabel,teacherLabel,locationLabel,numberLessonLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        NSLayoutConstraint.activate([
            startLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            startLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            startLabel.widthAnchor.constraint(equalToConstant: 40),
            
            endLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            endLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:16),
            endLabel.widthAnchor.constraint(equalToConstant: 40),
            
            verticalLine.centerXAnchor.constraint(equalTo: startLabel.centerXAnchor),
            verticalLine.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 4),
            verticalLine.bottomAnchor.constraint(equalTo: endLabel.topAnchor, constant: -4),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            
            
            lessonSpace.centerXAnchor.constraint(equalTo: verticalLine.centerXAnchor),
            lessonSpace.centerYAnchor.constraint(equalTo: verticalLine.centerYAnchor),
            lessonSpace.widthAnchor.constraint(equalToConstant: 24),
            lessonSpace.heightAnchor.constraint(equalToConstant: 24),
            
            numberLessonLabel.centerXAnchor.constraint(equalTo: lessonSpace.centerXAnchor),
            numberLessonLabel.centerYAnchor.constraint(equalTo: lessonSpace.centerYAnchor),
            
            
            
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainer.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            leftStripe.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant:0),
            leftStripe.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant:12),
            leftStripe.widthAnchor.constraint(equalToConstant: 4),
            leftStripe.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -12),
            
            subjectLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            subjectLabel.leadingAnchor.constraint(equalTo: leftStripe.trailingAnchor, constant: 12),
            subjectLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            
            teacherLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 4),
            teacherLabel.leadingAnchor.constraint(equalTo:subjectLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: teacherLabel.bottomAnchor,constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: subjectLabel.leadingAnchor),
            locationLabel.bottomAnchor.constraint(lessThanOrEqualTo:  cardContainer.bottomAnchor, constant: -12)
            
        ])
    }
    
    
    func setValue(slot: TimeSlot, lesson: Lesson?){
        startLabel.text = slot.startTime
        endLabel.text = slot.endTime
        numberLessonLabel.text = "\(slot.numOfLesson)"
        
        if let lesson = lesson {
            cardContainer.backgroundColor = .white
            cardContainer.layer.borderWidth = 0
            
            subjectLabel.isHidden = false
            locationLabel.isHidden = false
            teacherLabel.isHidden = false
            leftStripe.isHidden = false
            
            subjectLabel.text = lesson.subjectName
            teacherLabel.text = lesson.teacherName
            locationLabel.text = lesson.classroom
            
            leftStripe.backgroundColor  = lesson.subjectName.hashcolor;
        }
        else{
            cardContainer.backgroundColor = UIColor (white: 0.98, alpha: 0.5)
            cardContainer.layer.borderWidth = 1
            cardContainer.layer.borderColor = UIColor (white: 0.90, alpha: 1).cgColor
            cardContainer.layer.shadowOpacity = 0
            
            subjectLabel.isHidden = true
            locationLabel.isHidden = true
            teacherLabel.isHidden = true
            leftStripe.isHidden = true
        }
    }
    

}

extension String{
    var hashcolor: UIColor{
        let hash = self.hashValue
        let r = CGFloat((hash & 0xff0000) >> 16) / 255
        let g = CGFloat((hash & 0x00ff00) >> 8) / 255
        let b = CGFloat(hash & 0x0000ff) / 255
        
        return UIColor(red: abs(r), green: abs(g), blue: abs(b), alpha: 1.0)
        
    }
}
