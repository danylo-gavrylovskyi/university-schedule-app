import UIKit

// maybe return to consider extentoin for the centre in parent subview
public class DateCell: UICollectionViewCell{
    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let circleView = UIView()
    private let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {fatalError()}
    
    private func setUpUI(){
        circleView.layer.cornerRadius = 25
        circleView.backgroundColor = .clear
        
        dayLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dayLabel.textColor = .gray
        dayLabel.textAlignment = .center
        
        dateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        
        circleView.addSubview(dateLabel)
        
        stack.addArrangedSubview(dayLabel)
        stack.addArrangedSubview(circleView)
    
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.distribution = .fill
        
        contentView.addSubview(stack)
       
        stack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
 
            circleView.widthAnchor.constraint(equalToConstant: 50),
            circleView.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])
        
        contentView.addSubview(stack)
    }
    
    func setValue(date: Date, isSelected: Bool){
        let formatter = DateFormatter()
        
        formatter.dateFormat = "E"
        dayLabel.text = formatter.string(from: date)
        formatter.dateFormat = "d"
        dateLabel.text = formatter.string(from: date)
        
        if isSelected{
            circleView.backgroundColor = .systemBlue
            dateLabel.textColor = .white
            dayLabel.textColor = .systemBlue
        } else{
            circleView.backgroundColor = UIColor(white: 0.90, alpha:1)
            dateLabel.textColor = .black
            dayLabel.textColor = .gray
        }
        
    }
}
