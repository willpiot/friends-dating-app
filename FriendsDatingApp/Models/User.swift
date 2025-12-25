import Foundation

/// Represents a user in the Friends dating app
public struct User: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var age: Int
    public var bio: String
    public var photos: [String] // Photo URLs or identifiers
    public var quizResponses: QuizResponses?
    public var preferences: UserPreferences
    public var lastQuizUpdate: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        bio: String,
        photos: [String] = [],
        quizResponses: QuizResponses? = nil,
        preferences: UserPreferences = UserPreferences(),
        lastQuizUpdate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.photos = photos
        self.quizResponses = quizResponses
        self.preferences = preferences
        self.lastQuizUpdate = lastQuizUpdate
    }
    
    /// Check if quiz needs to be updated (30-day cycle)
    public var needsQuizUpdate: Bool {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return lastQuizUpdate < thirtyDaysAgo
    }
}

/// User preferences for date scheduling and matching
public struct UserPreferences: Codable {
    public var preferredLocations: [String]
    public var availableDays: Set<Weekday>
    public var availableTimeSlots: [TimeSlot]
    public var ageRangeMin: Int
    public var ageRangeMax: Int
    public var maxDistance: Double // in miles
    
    public init(
        preferredLocations: [String] = [],
        availableDays: Set<Weekday> = Set(Weekday.allCases),
        availableTimeSlots: [TimeSlot] = [],
        ageRangeMin: Int = 18,
        ageRangeMax: Int = 99,
        maxDistance: Double = 50
    ) {
        self.preferredLocations = preferredLocations
        self.availableDays = availableDays
        self.availableTimeSlots = availableTimeSlots
        self.ageRangeMin = ageRangeMin
        self.ageRangeMax = ageRangeMax
        self.maxDistance = maxDistance
    }
}

public enum Weekday: String, Codable, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public struct TimeSlot: Codable, Hashable {
    public var day: Weekday
    public var startHour: Int // 24-hour format
    public var endHour: Int
    
    public init(day: Weekday, startHour: Int, endHour: Int) {
        self.day = day
        self.startHour = startHour
        self.endHour = endHour
    }
}
