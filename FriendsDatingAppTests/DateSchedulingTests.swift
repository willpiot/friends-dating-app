import XCTest
@testable import FriendsDatingApp

final class DateSchedulingTests: XCTestCase {
    
    func testScheduledDateInitialization() {
        let date = Date()
        let scheduledDate = ScheduledDate(
            location: "Coffee Shop",
            dateTime: date,
            duration: 1800
        )
        
        XCTAssertEqual(scheduledDate.location, "Coffee Shop")
        XCTAssertEqual(scheduledDate.dateTime, date)
        XCTAssertEqual(scheduledDate.duration, 1800)
        XCTAssertNil(scheduledDate.user1Accepted)
        XCTAssertNil(scheduledDate.user2Accepted)
        XCTAssertFalse(scheduledDate.isConfirmed)
    }
    
    func testScheduledDateConfirmation() {
        var scheduledDate = ScheduledDate(
            location: "Park",
            dateTime: Date(),
            duration: 1800
        )
        
        // Not confirmed when only one accepts
        scheduledDate.user1Accepted = true
        XCTAssertFalse(scheduledDate.isConfirmed)
        
        // Confirmed when both accept
        scheduledDate.user2Accepted = true
        XCTAssertTrue(scheduledDate.isConfirmed)
    }
    
    func testMatchStatusTransitions() {
        var match = Match(
            user1Id: UUID(),
            user2Id: UUID(),
            similarityScore: 85.0
        )
        
        XCTAssertEqual(match.status, .pending)
        
        match.status = .accepted
        XCTAssertEqual(match.status, .accepted)
        
        match.status = .completed
        XCTAssertEqual(match.status, .completed)
    }
    
    func testDateSchedulingForMatch() {
        let user1 = User(
            name: "User1",
            age: 28,
            bio: "Bio",
            preferences: UserPreferences(
                preferredLocations: ["Coffee Shop"],
                availableTimeSlots: [
                    TimeSlot(day: .saturday, startHour: 10, endHour: 14)
                ]
            )
        )
        
        let user2 = User(
            name: "User2",
            age: 26,
            bio: "Bio",
            preferences: UserPreferences(
                preferredLocations: ["Coffee Shop"],
                availableTimeSlots: [
                    TimeSlot(day: .saturday, startHour: 12, endHour: 16)
                ]
            )
        )
        
        let match = Match(
            user1Id: user1.id,
            user2Id: user2.id,
            similarityScore: 90.0
        )
        
        let scheduledDate = DateSchedulingService.scheduleDateForMatch(
            match: match,
            user1: user1,
            user2: user2
        )
        
        XCTAssertNotNil(scheduledDate, "Should be able to schedule a date with overlapping availability")
        XCTAssertEqual(scheduledDate?.duration, 1800, "Date should be 30 minutes (1800 seconds)")
    }
}
