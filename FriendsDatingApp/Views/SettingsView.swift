import SwiftUI

/// Settings view for app configuration
public struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingQuiz = false
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            List {
                Section("Quiz") {
                    Button("Retake Quiz") {
                        showingQuiz = true
                    }
                    
                    if let lastUpdate = viewModel.user.quizResponses != nil ? viewModel.user.lastQuizUpdate : nil {
                        HStack {
                            Text("Last Updated")
                            Spacer()
                            Text(lastUpdate, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if viewModel.user.needsQuizUpdate {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Quiz update recommended (30+ days)")
                                .font(.caption)
                        }
                    }
                }
                
                Section("Preferences") {
                    Button("Edit Preferences") {
                        viewModel.isEditingPreferences = true
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                }
                
                Section("Account") {
                    Button("Log Out", role: .destructive) {
                        // Implement logout
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingQuiz) {
                QuizView(viewModel: QuizViewModel()) { responses in
                    viewModel.updateQuizResponses(responses)
                    showingQuiz = false
                }
            }
            .sheet(isPresented: $viewModel.isEditingPreferences) {
                PreferencesEditView(
                    preferences: viewModel.user.preferences,
                    onSave: { preferences in
                        viewModel.updatePreferences(preferences)
                    }
                )
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: ProfileViewModel(user: User(
        name: "John Doe",
        age: 28,
        bio: "Test user"
    )))
}
