import XCTest
@testable import FriendsDatingApp

final class QuizTests: XCTestCase {
    
    func testStandardQuizHas50Questions() {
        let quiz = Quiz.standard
        XCTAssertEqual(quiz.questions.count, 50, "Standard quiz should have exactly 50 questions")
    }
    
    func testLikertScaleWeights() {
        XCTAssertEqual(LikertScale.stronglyAgree.weight, 5)
        XCTAssertEqual(LikertScale.agree.weight, 3)
        XCTAssertEqual(LikertScale.neutral.weight, 1)
        XCTAssertEqual(LikertScale.disagree.weight, 2)
        XCTAssertEqual(LikertScale.stronglyDisagree.weight, 1)
    }
    
    func testQuizResponsesCompletion() {
        var responses = QuizResponses()
        XCTAssertFalse(responses.isComplete)
        
        // Add all 50 responses
        for i in 1...50 {
            responses.responses[i] = .neutral
        }
        
        XCTAssertTrue(responses.isComplete)
    }
    
    func testQuizQuestionCategories() {
        let quiz = Quiz.standard
        
        let personalityQuestions = quiz.questions.filter { $0.category == .personality }
        let interestQuestions = quiz.questions.filter { $0.category == .interests }
        let valueQuestions = quiz.questions.filter { $0.category == .values }
        let relationshipQuestions = quiz.questions.filter { $0.category == .relationship }
        
        XCTAssertGreaterThan(personalityQuestions.count, 0)
        XCTAssertGreaterThan(interestQuestions.count, 0)
        XCTAssertGreaterThan(valueQuestions.count, 0)
        XCTAssertGreaterThan(relationshipQuestions.count, 0)
    }
}
