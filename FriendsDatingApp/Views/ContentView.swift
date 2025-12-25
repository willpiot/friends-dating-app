import SwiftUI

/// Main app view with navigation
public struct ContentView: View {
    @StateObject private var profileViewModel: ProfileViewModel
    @StateObject private var matchViewModel = MatchViewModel()
    @State private var showingQuiz = false
    @State private var selectedTab = 0
    
    public init(user: User) {
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            // Matches Tab
            MatchesView(viewModel: matchViewModel, currentUser: profileViewModel.user)
                .tabItem {
                    Label("Matches", systemImage: "heart.fill")
                }
                .tag(0)
            
            // Profile Tab
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)
            
            // Settings Tab
            SettingsView(viewModel: profileViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .sheet(isPresented: $showingQuiz) {
            QuizView(viewModel: QuizViewModel()) { responses in
                profileViewModel.updateQuizResponses(responses)
                showingQuiz = false
            }
        }
        .onAppear {
            // Show quiz if needed
            if profileViewModel.user.quizResponses == nil || profileViewModel.user.needsQuizUpdate {
                showingQuiz = true
            }
        }
    }
}

#Preview {
    ContentView(user: User(
        name: "John Doe",
        age: 28,
        bio: "Looking for a meaningful connection"
    ))
}
