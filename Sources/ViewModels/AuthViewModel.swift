import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        let user = await authService.login(email: email, password: password)
        
        isLoading = false
        
        if let user = user {
            self.currentUser = user
            return true
        } else {
            errorMessage = "Invalid email or password"
            return false
        }
    }
    
    func logout() {
        authService.logout()
        currentUser = nil
        email = ""
        password = ""
        errorMessage = nil
    }
    
    func getCurrentUser() -> User? {
        return authService.getCurrentUser()
    }
}
