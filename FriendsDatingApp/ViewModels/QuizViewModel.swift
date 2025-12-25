import Foundation
import Combine

/// ViewModel for managing quiz state
public class QuizViewModel: ObservableObject {
    @Published public var currentQuestion: Int = 0
    @Published public var responses: [Int: LikertScale] = [:]
    @Published public var isComplete: Bool = false
    
    public let quiz: Quiz
    
    public init(quiz: Quiz = Quiz.standard) {
        self.quiz = quiz
    }
    
    public var progress: Double {
        return Double(responses.count) / Double(quiz.questions.count)
    }
    
    public var currentQuizQuestion: QuizQuestion? {
        guard currentQuestion < quiz.questions.count else { return nil }
        return quiz.questions[currentQuestion]
    }
    
    public func submitResponse(_ response: LikertScale, for questionId: Int) {
        responses[questionId] = response
        
        if responses.count == quiz.questions.count {
            isComplete = true
        }
    }
    
    public func nextQuestion() {
        if currentQuestion < quiz.questions.count - 1 {
            currentQuestion += 1
        }
    }
    
    public func previousQuestion() {
        if currentQuestion > 0 {
            currentQuestion -= 1
        }
    }
    
    public func getQuizResponses() -> QuizResponses {
        return QuizResponses(responses: responses)
    }
}
