import SwiftUI

/// View for displaying and taking the personality/interests quiz
public struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss
    let onComplete: (QuizResponses) -> Void
    
    public init(viewModel: QuizViewModel, onComplete: @escaping (QuizResponses) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onComplete = onComplete
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress bar
                ProgressView(value: viewModel.progress)
                    .padding()
                
                Text("Question \(viewModel.currentQuestion + 1) of 50")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Current question
                if let question = viewModel.currentQuizQuestion {
                    VStack(spacing: 30) {
                        Text(question.text)
                            .font(.title3)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // Likert scale options
                        VStack(spacing: 15) {
                            ForEach(LikertScale.allCases.reversed(), id: \.self) { scale in
                                Button(action: {
                                    viewModel.submitResponse(scale, for: question.id)
                                    
                                    if viewModel.isComplete {
                                        onComplete(viewModel.getQuizResponses())
                                    } else {
                                        viewModel.nextQuestion()
                                    }
                                }) {
                                    HStack {
                                        Text(scale.displayText)
                                            .font(.body)
                                        Spacer()
                                        if viewModel.responses[question.id] == scale {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(viewModel.responses[question.id] == scale ? 
                                                  Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if viewModel.currentQuestion > 0 {
                        Button("Previous") {
                            viewModel.previousQuestion()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.responses.count)/50 answered")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("Personality Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.responses.count >= 50 {
                        Button("Done") {
                            onComplete(viewModel.getQuizResponses())
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    QuizView(viewModel: QuizViewModel()) { _ in }
}
