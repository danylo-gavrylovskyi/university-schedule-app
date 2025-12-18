import UIKit
import SnapKit

final class AdminLessonCell: UITableViewCell {
    
    private let timeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private let startLessonTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let endLessonTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let lessonDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let lessonTypeLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier ?? "AdminLessonCell")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(timeStackView)
        contentView.addSubview(startLessonTimeLabel)
        contentView.addSubview(endLessonTimeLabel)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(lessonDetailsLabel)
        contentView.addSubview(lessonTypeLabel)
        contentView.addSubview(separator)
        
        timeStackView.addArrangedSubview(startLessonTimeLabel)
        timeStackView.addArrangedSubview(endLessonTimeLabel)
        
        timeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(55)
        }
        
        separator.snp.makeConstraints {
            $0.leading.equalTo(timeStackView.snp.trailing).offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(1)
        }
        
        lessonTypeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(12)
            $0.height.equalTo(20)
            $0.width.equalTo(70)
        }
        
        subjectLabel.snp.makeConstraints {
            $0.leading.equalTo(separator.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalTo(lessonTypeLabel.snp.leading).offset(-20)
        }
        
        lessonDetailsLabel.snp.makeConstraints {
            $0.leading.equalTo(subjectLabel)
            $0.top.equalTo(subjectLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func setup(lesson: Lesson) {
        subjectLabel.text = lesson.subjectName
        lessonDetailsLabel.text = "\(lesson.teacherName) | \(lesson.format) | \(lesson.classroom)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        startLessonTimeLabel.text = formatter.string(from: lesson.startTime)
        endLessonTimeLabel.text = formatter.string(from: lesson.endTime)
        
        if (lesson.type == .lecture) {
            lessonTypeLabel.text = "LECTURE"
            lessonTypeLabel.backgroundColor = .systemGreen
        }
        else if (lesson.type == .practice) {
            lessonTypeLabel.text = "PRACTICE"
            lessonTypeLabel.backgroundColor = .systemBlue
        }
    }
    
}
