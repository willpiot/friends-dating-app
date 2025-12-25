import Foundation
import Combine

/// ViewModel for managing user profile
public class ProfileViewModel: ObservableObject {
    @Published public var user: User
    @Published public var isEditingPreferences: Bool = false
    
    public init(user: User) {
        self.user = user
    }
    
    public func updatePreferences(_ preferences: UserPreferences) {
        user.preferences = preferences
        isEditingPreferences = false
    }
    
    public func addPhoto(_ photoId: String) {
        user.photos.append(photoId)
    }
    
    public func removePhoto(at index: Int) {
        guard index < user.photos.count else { return }
        user.photos.remove(at: index)
    }
    
    public func updateQuizResponses(_ responses: QuizResponses) {
        user.quizResponses = responses
        user.lastQuizUpdate = Date()
    }
}
