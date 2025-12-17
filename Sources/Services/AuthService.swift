import Foundation

public protocol AuthServiceProtocol {
    func login(email: String, password: String) async -> User?
    func getCurrentUser() -> User?
    func logout()
}

public final class AuthService: AuthServiceProtocol {
    
    private let userRepository: UserRepository
    private var currentUser: User?
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func login(email: String, password: String) async -> User? {
        guard !email.isEmpty, !password.isEmpty else { return nil }
        
        guard let user = await userRepository.getUserByEmail(email) else {
            return nil
        }
        
        guard user.passwordHash == password else {
            return nil
        }
        
        currentUser = user
        return user
    }
    
    public func getCurrentUser() -> User? {
        return currentUser
    }
    
    public func logout() {
        currentUser = nil
    }
}
