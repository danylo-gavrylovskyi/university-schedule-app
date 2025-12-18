import UIKit

protocol CalendarDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}


class CalendarHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    weak var delegate: CalendarDelegate?
    private var dates: [Date] = []
    private var selectedDateIndex: Int = 0
    
    
    private let monthLabel :UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.text = "December" //enchance in future
        return label
    }()
    
    private lazy var  collectionView: UICollectionView = {
        let layoutTimeLine =  UICollectionViewFlowLayout()
        layoutTimeLine.scrollDirection = .horizontal
        layoutTimeLine.itemSize = CGSize(width: 50, height: 70)
        layoutTimeLine.minimumLineSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutTimeLine)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        generateDates()
        setUpUI()
    }
    
    required init?(coder: NSCoder){fatalError()}
    
    // replace this hardcode
    private func generateDates(){
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<54{
            if let date = calendar.date(byAdding: .day, value: i, to: today){
                dates.append(date)
            }
        }
    }
    
    private func setUpUI(){
        
        addSubview(monthLabel)
        addSubview(collectionView)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor,constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier:"DateCell", for : indexPath) as! DateCell
        let date = dates[indexPath.row]
        let isSelected = indexPath.item == selectedDateIndex
        dateCell.setValue(date: date, isSelected: isSelected)
        return dateCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDateIndex = indexPath.row
        collectionView.reloadData()
        delegate?.didSelectDate(dates[indexPath.item])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func updateMonthLabel(for date : Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    
}
