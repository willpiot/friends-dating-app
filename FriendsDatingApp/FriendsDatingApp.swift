import SwiftUI

/// Main entry point for the Friends Dating App
@main
public struct FriendsDatingApp: App {
    // Initialize with a sample user for demonstration
    @State private var currentUser = User(
        id: UUID(),
        name: "Demo User",
        age: 28,
        bio: "Looking for meaningful connections based on shared values and interests.",
        photos: [],
        quizResponses: nil,
        preferences: UserPreferences(
            preferredLocations: ["Coffee Shop", "Park"],
            availableDays: [.saturday, .sunday],
            availableTimeSlots: [
                TimeSlot(day: .saturday, startHour: 10, endHour: 18),
                TimeSlot(day: .sunday, startHour: 12, endHour: 20)
            ],
            ageRangeMin: 25,
            ageRangeMax: 35,
            maxDistance: 25
        ),
        lastQuizUpdate: Date()
    )
    
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            ContentView(user: currentUser)
        }
    }
}
