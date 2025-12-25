import Foundation

/// Service for scheduling dates based on user preferences
public class DateSchedulingService {
    
    /// Schedule a 30-minute date between two users
    public static func scheduleDateForMatch(
        match: Match,
        user1: User,
        user2: User
    ) -> ScheduledDate? {
        // Find common available time slots
        let commonTimeSlots = findCommonTimeSlots(user1: user1, user2: user2)
        
        guard !commonTimeSlots.isEmpty else {
            return nil
        }
        
        // Select a random time slot from available options
        guard let selectedSlot = commonTimeSlots.randomElement() else {
            return nil
        }
        
        // Find common location preference
        let location = findCommonLocation(user1: user1, user2: user2)
        
        // Calculate next occurrence of the selected day
        let dateTime = calculateNextDateTime(for: selectedSlot)
        
        return ScheduledDate(
            location: location,
            dateTime: dateTime,
            duration: 1800 // 30 minutes
        )
    }
    
    /// Find time slots that work for both users
    private static func findCommonTimeSlots(user1: User, user2: User) -> [TimeSlot] {
        let user1Slots = user1.preferences.availableTimeSlots
        let user2Slots = user2.preferences.availableTimeSlots
        
        // Find overlapping time slots
        var commonSlots: [TimeSlot] = []
        
        for slot1 in user1Slots {
            for slot2 in user2Slots {
                if slot1.day == slot2.day {
                    // Check if times overlap
                    let overlapStart = max(slot1.startHour, slot2.startHour)
                    let overlapEnd = min(slot1.endHour, slot2.endHour)
                    
                    if overlapStart < overlapEnd {
                        commonSlots.append(TimeSlot(
                            day: slot1.day,
                            startHour: overlapStart,
                            endHour: overlapEnd
                        ))
                    }
                }
            }
        }
        
        return commonSlots
    }
    
    /// Find a common location or default to a neutral location
    private static func findCommonLocation(user1: User, user2: User) -> String {
        let user1Locations = Set(user1.preferences.preferredLocations)
        let user2Locations = Set(user2.preferences.preferredLocations)
        
        let commonLocations = user1Locations.intersection(user2Locations)
        
        if let location = commonLocations.randomElement() {
            return location
        }
        
        // Default locations if no common preference
        let defaultLocations = ["Coffee Shop", "Park", "Restaurant", "Café", "Library"]
        return defaultLocations.randomElement() ?? "Coffee Shop"
    }
    
    /// Calculate the next occurrence of a given time slot
    private static func calculateNextDateTime(for slot: TimeSlot) -> Date {
        let calendar = Calendar.current
        let now = Date()
        
        // Map Weekday to Calendar weekday
        let targetWeekday = weekdayToCalendarWeekday(slot.day)
        
        // Find next occurrence of target weekday
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = targetWeekday
        components.hour = slot.startHour
        components.minute = 0
        components.second = 0
        
        if let nextDate = calendar.date(from: components) {
            // If the date is in the past, add a week
            if nextDate < now {
                return calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate) ?? nextDate
            }
            return nextDate
        }
        
        // Fallback to tomorrow at the specified hour
        return calendar.date(byAdding: .day, value: 1, to: now) ?? now
    }
    
    /// Convert custom Weekday enum to Calendar weekday
    private static func weekdayToCalendarWeekday(_ weekday: Weekday) -> Int {
        switch weekday {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}
