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
                    
                    if viewModel.user.quizResponses != nil {
                        HStack {
                            Text("Last Updated")
                            Spacer()
                            Text(viewModel.user.lastQuizUpdate, style: .date)
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
                    
                    // TODO: Replace with actual production URLs
                    if let privacyURL = URL(string: "https://example.com/privacy") {
                        Link("Privacy Policy", destination: privacyURL)
                    }
                    if let termsURL = URL(string: "https://example.com/terms") {
                        Link("Terms of Service", destination: termsURL)
                    }
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
