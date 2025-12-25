import Foundation

/// Represents a match between two users
public struct Match: Identifiable, Codable {
    public let id: UUID
    public let user1Id: UUID
    public let user2Id: UUID
    public let similarityScore: Double
    public let matchDate: Date
    public var status: MatchStatus
    public var scheduledDate: ScheduledDate?
    
    public init(
        id: UUID = UUID(),
        user1Id: UUID,
        user2Id: UUID,
        similarityScore: Double,
        matchDate: Date = Date(),
        status: MatchStatus = .pending,
        scheduledDate: ScheduledDate? = nil
    ) {
        self.id = id
        self.user1Id = user1Id
        self.user2Id = user2Id
        self.similarityScore = similarityScore
        self.matchDate = matchDate
        self.status = status
        self.scheduledDate = scheduledDate
    }
}

public enum MatchStatus: String, Codable {
    case pending        // Waiting for user responses
    case accepted       // Both users accepted
    case declined       // One or both declined
    case completed      // Date completed
}

/// Represents a scheduled 30-minute date
public struct ScheduledDate: Codable {
    public let id: UUID
    public var location: String
    public var dateTime: Date
    public var duration: TimeInterval // 30 minutes = 1800 seconds
    public var user1Accepted: Bool?
    public var user2Accepted: Bool?
    
    public init(
        id: UUID = UUID(),
        location: String,
        dateTime: Date,
        duration: TimeInterval = 1800, // 30 minutes
        user1Accepted: Bool? = nil,
        user2Accepted: Bool? = nil
    ) {
        self.id = id
        self.location = location
        self.dateTime = dateTime
        self.duration = duration
        self.user1Accepted = user1Accepted
        self.user2Accepted = user2Accepted
    }
    
    public var isConfirmed: Bool {
        return user1Accepted == true && user2Accepted == true
    }
}

/// Calculates similarity between users based on quiz responses
public struct SimilarityCalculator {
    
    /// Calculate similarity score between two users
    /// Returns a score from 0 to 100 (percentage)
    public static func calculateSimilarity(user1: User, user2: User) -> Double {
        guard let responses1 = user1.quizResponses,
              let responses2 = user2.quizResponses,
              responses1.isComplete && responses2.isComplete else {
            return 0
        }
        
        var totalPoints = 0.0
        var maxPoints = 0.0
        
        // Calculate quiz similarity with weighted scoring
        for questionId in 1...50 {
            guard let response1 = responses1.responses[questionId],
                  let response2 = responses2.responses[questionId] else {
                continue
            }
            
            let weight1 = Double(response1.weight)
            let weight2 = Double(response2.weight)
            
            // Calculate difference between responses
            let difference = abs(response1.rawValue - response2.rawValue)
            
            // Award points based on similarity (inverse of difference)
            // Max difference is 4 (5-1), so we normalize
            let similarityFactor = 1.0 - (Double(difference) / 4.0)
            
            // Use average weight for this question pair
            let avgWeight = (weight1 + weight2) / 2.0
            
            totalPoints += similarityFactor * avgWeight
            maxPoints += avgWeight
        }
        
        let quizScore = maxPoints > 0 ? (totalPoints / maxPoints) * 100 : 0
        
        // Factor in age compatibility (10% weight)
        let ageDifference = abs(user1.age - user2.age)
        let ageCompatibility = max(0, 100 - Double(ageDifference) * 5) // 5% penalty per year difference
        
        // Combine scores: 80% quiz, 10% age, 10% reserved for physical (photos)
        // Physical attraction is simplified here - in production would use photo analysis
        let physicalScore = 50.0 // Neutral baseline
        
        let finalScore = (quizScore * 0.80) + (ageCompatibility * 0.10) + (physicalScore * 0.10)
        
        return min(100, max(0, finalScore))
    }
}
