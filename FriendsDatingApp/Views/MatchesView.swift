import SwiftUI

/// View for displaying weekly matches
public struct MatchesView: View {
    @ObservedObject var viewModel: MatchViewModel
    let currentUser: User
    @State private var showingProfile = false
    @State private var selectedMatch: Match?
    
    public init(viewModel: MatchViewModel, currentUser: User) {
        self.viewModel = viewModel
        self.currentUser = currentUser
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Your Weekly Matches")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    if viewModel.weeklyMatches.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No matches yet")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Text("We're finding the perfect matches for you!")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Button("Refresh Matches") {
                                // Load sample users for demo
                                viewModel.loadWeeklyMatches(for: currentUser, allUsers: [])
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top)
                        }
                        .padding()
                    } else {
                        ForEach(viewModel.weeklyMatches.filter { $0.status == .pending }) { match in
                            MatchCard(
                                match: match,
                                currentUserId: currentUser.id,
                                onViewProfile: {
                                    selectedMatch = match
                                    viewModel.loadPartnerProfile(for: match)
                                    showingProfile = true
                                },
                                onAccept: {
                                    viewModel.acceptMatch(match, for: currentUser.id)
                                },
                                onDecline: {
                                    viewModel.declineMatch(match)
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Matches")
            .sheet(isPresented: $showingProfile) {
                if let partner = viewModel.partnerProfile, let match = selectedMatch {
                    PartnerProfileView(
                        partner: partner,
                        match: match,
                        onAccept: {
                            viewModel.acceptMatch(match, for: currentUser.id)
                            showingProfile = false
                        },
                        onDecline: {
                            viewModel.declineMatch(match)
                            showingProfile = false
                        }
                    )
                }
            }
            .onAppear {
                // Load matches if empty
                if viewModel.weeklyMatches.isEmpty {
                    // In production, load from backend
                    viewModel.loadWeeklyMatches(for: currentUser, allUsers: [])
                }
            }
        }
    }
}

/// Card displaying a single match
struct MatchCard: View {
    let match: Match
    let currentUserId: UUID
    let onViewProfile: () -> Void
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Match score
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("\(Int(match.similarityScore))% Match")
                    .font(.headline)
                    .foregroundColor(.pink)
                Spacer()
                Text("New")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Date details
            if let scheduledDate = match.scheduledDate {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                        Text(scheduledDate.dateTime, style: .date)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(scheduledDate.dateTime, style: .time)
                        Text("(30 min)")
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "mappin.circle")
                        Text(scheduledDate.location)
                    }
                    .font(.subheadline)
                }
                .foregroundColor(.secondary)
            }
            
            // Action buttons
            HStack(spacing: 15) {
                Button(action: onViewProfile) {
                    Label("View Profile", systemImage: "person.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button(action: onAccept) {
                    Label("Accept", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button(action: onDecline) {
                    Label("Decline", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    MatchesView(
        viewModel: MatchViewModel(),
        currentUser: User(name: "John", age: 28, bio: "Test")
    )
}
