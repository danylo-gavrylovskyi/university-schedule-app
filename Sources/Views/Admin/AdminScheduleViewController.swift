import UIKit
import SnapKit
import Combine

final class AdminScheduleViewController: UIViewController {
    
    private let viewModel = LessonsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView  = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
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
        let editorVM = LessonEditorViewModel()
        let viewController = LessonEditorViewController(viewModel: editorVM)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$sections.receive(on: RunLoop.main).sink { _ in self.tableView.reloadData() }.store(in: &cancellables)
    }
}

extension AdminScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].lessons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.sections[section].date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date).uppercased()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminLessonCell", for: indexPath) as? AdminLessonCell else {
            return UITableViewCell()
        }
        let lesson = viewModel.sections[indexPath.section].lessons[indexPath.row]
        cell.setup(lesson: lesson)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            self.viewModel.deleteLesson(section: indexPath.section, row: indexPath.row)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") {_,_,_ in
            let lesson = self.viewModel.sections[indexPath.section].lessons[indexPath.row]
            
            let editorVM = LessonEditorViewModel(lesson: lesson)
            let viewController = LessonEditorViewController(viewModel: editorVM)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        edit.backgroundColor = .systemOrange
        
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
