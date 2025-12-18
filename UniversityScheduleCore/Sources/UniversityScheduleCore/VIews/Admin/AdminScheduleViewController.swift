import UIKit
import SnapKit
import Combine

final public class AdminScheduleViewController: UIViewController {
    
    private let viewModel: LessonsViewModel
    private let scheduleService: ScheduleServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView  = UITableView()
    
    public init(viewModel: LessonsViewModel, scheduleService: ScheduleServiceProtocol) {
        self.viewModel = viewModel
        self.scheduleService = scheduleService
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {fatalError()}
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.loadLessons()
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(AdminLessonCell.self, forCellReuseIdentifier: "AdminLessonCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddLesson))
    }
    
    @objc private func handleAddLesson() {
        let editorVM = LessonEditorViewModel(scheduleService: scheduleService)
        let viewController = LessonEditorViewController(viewModel: editorVM)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$sections.receive(on: RunLoop.main).sink { _ in self.tableView.reloadData() }.store(in: &cancellables)
    }
}

extension AdminScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].lessons.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.sections[section].date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date).uppercased()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminLessonCell", for: indexPath) as? AdminLessonCell else {
            return UITableViewCell()
        }
        let lesson = viewModel.sections[indexPath.section].lessons[indexPath.row]
        cell.setup(lesson: lesson)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,_ in
            Task {
                await self?.viewModel.deleteLesson(section: indexPath.section, row: indexPath.row)
            }
        }
            
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] _,_,_ in
            guard let self = self else { return }
            let lesson = self.viewModel.sections[indexPath.section].lessons[indexPath.row]
            let editorVM = LessonEditorViewModel(
                lesson: lesson,
                scheduleService: self.scheduleService
            )
                
            let viewController = LessonEditorViewController(viewModel: editorVM)
            self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            edit.backgroundColor = UIColor.systemOrange
            return UISwipeActionsConfiguration(actions: [delete, edit])
        }
    
}

//#if DEBUG
//
//import SwiftUI
//
//struct AdminScheduleViewController_Preview: PreviewProvider {
//
//    static var previews: some View {
//        ViewControllerWrapper(controller: UINavigationController(rootViewController: AdminScheduleViewController()))
//    }
//
//}
//
//#endif
