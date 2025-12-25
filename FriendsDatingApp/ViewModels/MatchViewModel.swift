import Foundation
import Combine

/// ViewModel for managing matches and dates
public class MatchViewModel: ObservableObject {
    @Published public var weeklyMatches: [Match] = []
    @Published public var selectedMatch: Match?
    @Published public var partnerProfile: User?
    
    private var allUsers: [User] = []
    
    public init() {}
    
    public func loadWeeklyMatches(for user: User, allUsers: [User]) {
        self.allUsers = allUsers
        
        // Check if user already has matches this week
        if !MatchingService.hasWeeklyMatches(userId: user.id, existingMatches: weeklyMatches) {
            // Find new matches
            weeklyMatches = MatchingService.findWeeklyMatches(for: user, from: allUsers)
            
            // Schedule dates for each match
            for (index, match) in weeklyMatches.enumerated() {
                if let partner = allUsers.first(where: { $0.id == match.user2Id }) {
                    let scheduledDate = DateSchedulingService.scheduleDateForMatch(
                        match: match,
                        user1: user,
                        user2: partner
                    )
                    weeklyMatches[index].scheduledDate = scheduledDate
                }
            }
        }
    }
    
    public func acceptMatch(_ match: Match, for userId: UUID) {
        guard let index = weeklyMatches.firstIndex(where: { $0.id == match.id }) else {
            return
        }
        
        // Update the scheduled date acceptance status
        if var scheduledDate = weeklyMatches[index].scheduledDate {
            if weeklyMatches[index].user1Id == userId {
                scheduledDate.user1Accepted = true
            } else if weeklyMatches[index].user2Id == userId {
                scheduledDate.user2Accepted = true
            }
            
            weeklyMatches[index].scheduledDate = scheduledDate
            
            // Check if both accepted and update status
            if scheduledDate.isConfirmed {
                weeklyMatches[index].status = .accepted
            }
        }
    }
    
    public func declineMatch(_ match: Match) {
        guard let index = weeklyMatches.firstIndex(where: { $0.id == match.id }) else {
            return
        }
        
        weeklyMatches[index].status = .declined
    }
    
    public func loadPartnerProfile(for match: Match) {
        // Determine which user is the partner
        let partnerId = match.user2Id
        partnerProfile = allUsers.first(where: { $0.id == partnerId })
    }
}
