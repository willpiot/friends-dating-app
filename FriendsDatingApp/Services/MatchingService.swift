import Foundation

/// Service for managing user matching using AI-based similarity
public class MatchingService {
    
    /// Find top 3 matches for a user for the week
    public static func findWeeklyMatches(for user: User, from candidates: [User]) -> [Match] {
        guard user.quizResponses?.isComplete == true else {
            return []
        }
        
        // Filter candidates based on preferences
        let eligibleCandidates = candidates.filter { candidate in
            guard candidate.id != user.id else { return false }
            guard candidate.quizResponses?.isComplete == true else { return false }
            
            // Check age range
            if candidate.age < user.preferences.ageRangeMin || 
               candidate.age > user.preferences.ageRangeMax {
                return false
            }
            
            // Check mutual age compatibility
            if user.age < candidate.preferences.ageRangeMin || 
               user.age > candidate.preferences.ageRangeMax {
                return false
            }
            
            return true
        }
        
        // Calculate similarity scores for all eligible candidates
        let scoredCandidates = eligibleCandidates.map { candidate in
            (candidate: candidate, 
             score: SimilarityCalculator.calculateSimilarity(user1: user, user2: candidate))
        }
        
        // Sort by similarity score (descending) and take top 3
        let topMatches = scoredCandidates
            .sorted { $0.score > $1.score }
            .prefix(3)
        
        // Create match objects
        return topMatches.map { item in
            Match(
                user1Id: user.id,
                user2Id: item.candidate.id,
                similarityScore: item.score,
                status: .pending
            )
        }
    }
    
    /// Check if a user has already been matched this week
    public static func hasWeeklyMatches(userId: UUID, existingMatches: [Match]) -> Bool {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        let recentMatches = existingMatches.filter { match in
            (match.user1Id == userId || match.user2Id == userId) && 
            match.matchDate > weekAgo
        }
        
        return recentMatches.count >= 3
    }
}
