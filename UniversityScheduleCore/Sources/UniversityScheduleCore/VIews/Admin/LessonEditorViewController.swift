import UIKit
import SnapKit

final class LessonEditorViewController: UIViewController {
    
    private let viewModel: LessonEditorViewModel
    
    private let scrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        return stack
    }()
    
    private let subjectTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Subject"
        text.borderStyle = .roundedRect
        return text
    }()
    
    private let teacherTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Teacher"
        text.borderStyle = .roundedRect
        return text
    }()
    
    private let classroomTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Classroom / Meeting Link"
        text.borderStyle = .roundedRect
        return text
    }()
    
    private let lessonTypeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Lecture", "Practice"])
        return control
    }()
    
    private let lessonFormatControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Offline", "Online"])
        return control
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    private let lessonDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let lessonTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let lessonFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "Format"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let lessonStartLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let lessonEndLabel: UILabel = {
        let label = UILabel()
        label.text = "End"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    init(viewModel: LessonEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        title = viewModel.title
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.addArrangedSubview(lessonDetailsLabel)
        stackView.addArrangedSubview(subjectTextField)
        stackView.addArrangedSubview(teacherTextField)
        stackView.addArrangedSubview(classroomTextField)
        
        stackView.addArrangedSubview(lessonTypeLabel)
        stackView.addArrangedSubview(lessonTypeControl)
        
        stackView.addArrangedSubview(lessonFormatLabel)
        stackView.addArrangedSubview(lessonFormatControl)
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(lessonStartLabel)
        stackView.addArrangedSubview(startDatePicker)
        stackView.addArrangedSubview(lessonEndLabel)
        stackView.addArrangedSubview(endDatePicker)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveLesson))
    }

    private func bindViewModel() {
        subjectTextField.text = viewModel.subjectName
        teacherTextField.text = viewModel.teacherName
        classroomTextField.text = viewModel.classroom
        lessonTypeControl.selectedSegmentIndex = (viewModel.type == .lecture) ? 0 : 1
        lessonFormatControl.selectedSegmentIndex = (viewModel.format == .offline) ? 0 : 1
        startDatePicker.date = viewModel.startTime
        endDatePicker.date = viewModel.endTime
        
        subjectTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        teacherTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        classroomTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        lessonTypeControl.addTarget(self, action: #selector(handleSelectChanged), for: .valueChanged)
        lessonFormatControl.addTarget(self, action: #selector(handleSelectChanged), for: .valueChanged)
        startDatePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(handleDateChanged), for: .valueChanged)
    }

    @objc private func handleSaveLesson() {
        Task {
            let success = await viewModel.saveLesson()
            if success {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func handleTextChanged(_ text: UITextField) {
        if text == subjectTextField { viewModel.subjectName = text.text ?? "" }
        if text == teacherTextField { viewModel.teacherName = text.text ?? "" }
        if text == classroomTextField { viewModel.classroom = text.text ?? "" }
    }
    
    @objc private func handleSelectChanged(_ select: UISegmentedControl) {
        if select == lessonTypeControl { viewModel.type = select.selectedSegmentIndex == 0 ? .lecture : .practice }
        if select == lessonFormatControl { viewModel.format = select.selectedSegmentIndex == 0 ? .offline : .online }
    }
    
    @objc private func handleDateChanged(_ date: UIDatePicker) {
        if date == startDatePicker { viewModel.startTime = date.date }
        if date == endDatePicker { viewModel.endTime = date.date }
    }
}

#if DEBUG

import SwiftUI

struct LessonEdutirViewController_Preview: PreviewProvider {

    static var previews: some View {
        let repo = InMemoryLessonRepository()
        let validation = ValidationService()
        let service = ScheduleService(lessonRepository: repo, validationService: validation)
        let vm = LessonEditorViewModel(scheduleService: service)
        ViewControllerWrapper(controller: UINavigationController(rootViewController: LessonEditorViewController(viewModel: vm)))
    }

}

#endif
