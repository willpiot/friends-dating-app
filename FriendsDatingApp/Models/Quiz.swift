import Foundation

/// Represents the 50-question personality and interests quiz
public struct Quiz: Codable {
    public let id: UUID
    public let questions: [QuizQuestion]
    
    public init(id: UUID = UUID(), questions: [QuizQuestion]) {
        self.id = id
        self.questions = questions
    }
    
    /// Standard 50-question quiz for personality and interests assessment
    public static let standard: Quiz = {
        let questions = [
            // Personality traits
            QuizQuestion(id: 1, text: "I enjoy spending time in large social gatherings", category: .personality),
            QuizQuestion(id: 2, text: "I prefer structured routines over spontaneity", category: .personality),
            QuizQuestion(id: 3, text: "I make decisions based on logic rather than emotions", category: .personality),
            QuizQuestion(id: 4, text: "I am optimistic about the future", category: .personality),
            QuizQuestion(id: 5, text: "I enjoy deep philosophical conversations", category: .personality),
            QuizQuestion(id: 6, text: "I am comfortable expressing my emotions", category: .personality),
            QuizQuestion(id: 7, text: "I prefer to lead rather than follow", category: .personality),
            QuizQuestion(id: 8, text: "I am detail-oriented in my work", category: .personality),
            QuizQuestion(id: 9, text: "I adapt easily to change", category: .personality),
            QuizQuestion(id: 10, text: "I enjoy helping others with their problems", category: .personality),
            
            // Interests - Hobbies
            QuizQuestion(id: 11, text: "I enjoy outdoor activities and nature", category: .interests),
            QuizQuestion(id: 12, text: "I am passionate about fitness and health", category: .interests),
            QuizQuestion(id: 13, text: "I enjoy reading books regularly", category: .interests),
            QuizQuestion(id: 14, text: "I am interested in arts and creativity", category: .interests),
            QuizQuestion(id: 15, text: "I enjoy cooking and trying new recipes", category: .interests),
            QuizQuestion(id: 16, text: "I like watching movies and TV series", category: .interests),
            QuizQuestion(id: 17, text: "I enjoy playing video games", category: .interests),
            QuizQuestion(id: 18, text: "I am interested in technology and gadgets", category: .interests),
            QuizQuestion(id: 19, text: "I enjoy traveling and exploring new places", category: .interests),
            QuizQuestion(id: 20, text: "I am passionate about music", category: .interests),
            
            // Values and lifestyle
            QuizQuestion(id: 21, text: "Family is the most important thing in my life", category: .values),
            QuizQuestion(id: 22, text: "I have strong religious or spiritual beliefs", category: .values),
            QuizQuestion(id: 23, text: "Career success is a top priority for me", category: .values),
            QuizQuestion(id: 24, text: "I believe in traditional gender roles", category: .values),
            QuizQuestion(id: 25, text: "Financial security is very important to me", category: .values),
            QuizQuestion(id: 26, text: "I want to have children in the future", category: .values),
            QuizQuestion(id: 27, text: "I prefer living in urban areas over rural", category: .values),
            QuizQuestion(id: 28, text: "Environmental conservation is important to me", category: .values),
            QuizQuestion(id: 29, text: "I value personal freedom and independence", category: .values),
            QuizQuestion(id: 30, text: "I believe in lifelong learning and education", category: .values),
            
            // Relationship expectations
            QuizQuestion(id: 31, text: "I believe in love at first sight", category: .relationship),
            QuizQuestion(id: 32, text: "Physical attraction is crucial in a relationship", category: .relationship),
            QuizQuestion(id: 33, text: "I prefer frequent communication with my partner", category: .relationship),
            QuizQuestion(id: 34, text: "I value quality time together over gifts", category: .relationship),
            QuizQuestion(id: 35, text: "I am comfortable with public displays of affection", category: .relationship),
            QuizQuestion(id: 36, text: "I believe partners should share all their passwords", category: .relationship),
            QuizQuestion(id: 37, text: "I think couples should have separate hobbies", category: .relationship),
            QuizQuestion(id: 38, text: "I am willing to relocate for the right partner", category: .relationship),
            QuizQuestion(id: 39, text: "I believe in maintaining friendships with exes", category: .relationship),
            QuizQuestion(id: 40, text: "Financial transparency is essential in relationships", category: .relationship),
            
            // Additional personality and compatibility
            QuizQuestion(id: 41, text: "I prefer quiet evenings at home over going out", category: .personality),
            QuizQuestion(id: 42, text: "I am punctual and value timeliness", category: .personality),
            QuizQuestion(id: 43, text: "I enjoy intellectual debates and discussions", category: .interests),
            QuizQuestion(id: 44, text: "I believe in astrology and zodiac compatibility", category: .values),
            QuizQuestion(id: 45, text: "I am comfortable with long-distance relationships", category: .relationship),
            QuizQuestion(id: 46, text: "I think it's important to have similar political views", category: .values),
            QuizQuestion(id: 47, text: "I enjoy surprises and spontaneous dates", category: .personality),
            QuizQuestion(id: 48, text: "I am an early riser and morning person", category: .personality),
            QuizQuestion(id: 49, text: "I believe couples should maintain separate finances", category: .values),
            QuizQuestion(id: 50, text: "I value emotional intimacy over physical intimacy", category: .relationship),
        ]
        return Quiz(questions: questions)
    }()
}

public struct QuizQuestion: Codable, Identifiable {
    public let id: Int
    public let text: String
    public let category: QuestionCategory
    
    public init(id: Int, text: String, category: QuestionCategory) {
        self.id = id
        self.text = text
        self.category = category
    }
}

public enum QuestionCategory: String, Codable {
    case personality
    case interests
    case values
    case relationship
}

/// User's responses to the quiz using 5-point Likert scale
public struct QuizResponses: Codable {
    public var responses: [Int: LikertScale] // Question ID to response
    
    public init(responses: [Int: LikertScale] = [:]) {
        self.responses = responses
    }
    
    public var isComplete: Bool {
        return responses.count == 50
    }
}

/// 5-point Likert scale with weighted scoring
public enum LikertScale: Int, Codable, CaseIterable {
    case stronglyDisagree = 1  // Weight: 1
    case disagree = 2           // Weight: 2
    case neutral = 3            // Weight: 1
    case agree = 4              // Weight: 3
    case stronglyAgree = 5      // Weight: 5
    
    /// Get the weight for similarity calculation
    public var weight: Int {
        switch self {
        case .stronglyAgree: return 5
        case .agree: return 3
        case .neutral: return 1
        case .disagree: return 2
        case .stronglyDisagree: return 1
        }
    }
    
    public var displayText: String {
        switch self {
        case .stronglyDisagree: return "Strongly Disagree"
        case .disagree: return "Disagree"
        case .neutral: return "Neutral"
        case .agree: return "Agree"
        case .stronglyAgree: return "Strongly Agree"
        }
    }
}
