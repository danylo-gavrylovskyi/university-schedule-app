import SwiftUI

extension UIViewController {
    func asPreview() -> some View {
        ViewControllerWrapper(controller: self)
    }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
}
