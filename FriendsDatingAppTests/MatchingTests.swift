import XCTest
@testable import FriendsDatingApp

final class MatchingTests: XCTestCase {
    
    func testSimilarityCalculation() {
        // Create two users with identical responses
        var responses1 = QuizResponses()
        var responses2 = QuizResponses()
        
        for i in 1...50 {
            responses1.responses[i] = .agree
            responses2.responses[i] = .agree
        }
        
        let user1 = User(name: "User1", age: 28, bio: "Bio", quizResponses: responses1)
        let user2 = User(name: "User2", age: 28, bio: "Bio", quizResponses: responses2)
        
        let similarity = SimilarityCalculator.calculateSimilarity(user1: user1, user2: user2)
        
        // Should be very high since responses are identical
        XCTAssertGreaterThan(similarity, 90.0, "Identical responses should result in high similarity")
    }
    
    func testSimilarityWithDifferentResponses() {
        var responses1 = QuizResponses()
        var responses2 = QuizResponses()
        
        for i in 1...50 {
            responses1.responses[i] = .stronglyAgree
            responses2.responses[i] = .stronglyDisagree
        }
        
        let user1 = User(name: "User1", age: 28, bio: "Bio", quizResponses: responses1)
        let user2 = User(name: "User2", age: 28, bio: "Bio", quizResponses: responses2)
        
        let similarity = SimilarityCalculator.calculateSimilarity(user1: user1, user2: user2)
        
        // Should be low since responses are opposite
        XCTAssertLessThan(similarity, 50.0, "Opposite responses should result in low similarity")
    }
    
    func testFindWeeklyMatchesReturnsTop3() {
        var user = User(name: "Main User", age: 28, bio: "Bio")
        var responses = QuizResponses()
        
        for i in 1...50 {
            responses.responses[i] = .agree
        }
        user.quizResponses = responses
        
        // Create 5 candidate users with varying similarity
        var candidates: [User] = []
        for i in 1...5 {
            var candidate = User(name: "Candidate \(i)", age: 28, bio: "Bio")
            var candidateResponses = QuizResponses()
            
            for j in 1...50 {
                candidateResponses.responses[j] = i <= 2 ? .agree : .stronglyDisagree
            }
            candidate.quizResponses = candidateResponses
            candidates.append(candidate)
        }
        
        let matches = MatchingService.findWeeklyMatches(for: user, from: candidates)
        
        XCTAssertEqual(matches.count, 3, "Should return exactly 3 matches")
    }
    
    func testAgeCompatibilityFiltering() {
        var user = User(name: "Main User", age: 28, bio: "Bio")
        var responses = QuizResponses()
        
        for i in 1...50 {
            responses.responses[i] = .agree
        }
        user.quizResponses = responses
        user.preferences.ageRangeMin = 25
        user.preferences.ageRangeMax = 32
        
        // Create candidates with different ages
        var youngCandidate = User(name: "Too Young", age: 20, bio: "Bio")
        youngCandidate.quizResponses = responses
        
        var oldCandidate = User(name: "Too Old", age: 40, bio: "Bio")
        oldCandidate.quizResponses = responses
        
        var goodCandidate = User(name: "Good Age", age: 30, bio: "Bio")
        goodCandidate.quizResponses = responses
        
        let matches = MatchingService.findWeeklyMatches(
            for: user,
            from: [youngCandidate, oldCandidate, goodCandidate]
        )
        
        // Should only match with the candidate in the age range
        XCTAssertEqual(matches.count, 1, "Should only match with users in age range")
    }
}
