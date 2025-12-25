import XCTest
@testable import FriendsDatingApp

final class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let user = User(
            name: "John Doe",
            age: 28,
            bio: "Test bio"
        )
        
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.age, 28)
        XCTAssertEqual(user.bio, "Test bio")
        XCTAssertTrue(user.photos.isEmpty)
        XCTAssertNil(user.quizResponses)
    }
    
    func testQuizUpdateNeeded() {
        // User with recent quiz
        var recentUser = User(name: "Recent", age: 28, bio: "Bio")
        recentUser.lastQuizUpdate = Date()
        XCTAssertFalse(recentUser.needsQuizUpdate, "Recent quiz should not need update")
        
        // User with old quiz (31 days ago)
        var oldUser = User(name: "Old", age: 28, bio: "Bio")
        oldUser.lastQuizUpdate = Calendar.current.date(byAdding: .day, value: -31, to: Date())!
        XCTAssertTrue(oldUser.needsQuizUpdate, "Quiz older than 30 days should need update")
    }
    
    func testUserPreferencesDefaults() {
        let preferences = UserPreferences()
        
        XCTAssertEqual(preferences.ageRangeMin, 18)
        XCTAssertEqual(preferences.ageRangeMax, 99)
        XCTAssertEqual(preferences.maxDistance, 50)
        XCTAssertEqual(preferences.availableDays.count, 7)
    }
    
    func testTimeSlotCreation() {
        let timeSlot = TimeSlot(day: .monday, startHour: 9, endHour: 17)
        
        XCTAssertEqual(timeSlot.day, .monday)
        XCTAssertEqual(timeSlot.startHour, 9)
        XCTAssertEqual(timeSlot.endHour, 17)
    }
}
