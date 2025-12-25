import SwiftUI

/// View for displaying partner's profile after matching
public struct PartnerProfileView: View {
    let partner: User
    let match: Match
    let onAccept: () -> Void
    let onDecline: () -> Void
    @Environment(\.dismiss) var dismiss
    
    public init(partner: User, match: Match, onAccept: @escaping () -> Void, onDecline: @escaping () -> Void) {
        self.partner = partner
        self.match = match
        self.onAccept = onAccept
        self.onDecline = onDecline
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo placeholder
                    if partner.photos.isEmpty {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    } else {
                        // In production, load actual photos
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                    
                    // Basic info
                    VStack(spacing: 10) {
                        Text(partner.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("\(partner.age) years old")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        // Match score
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                            Text("\(Int(match.similarityScore))% Compatibility")
                                .font(.headline)
                                .foregroundColor(.pink)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.pink.opacity(0.1))
                        )
                    }
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.headline)
                        Text(partner.bio)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Scheduled date info
                    if let scheduledDate = match.scheduledDate {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date Details")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "calendar")
                                Text(scheduledDate.dateTime, style: .date)
                            }
                            
                            HStack {
                                Image(systemName: "clock")
                                Text(scheduledDate.dateTime, style: .time)
                                Text("(30 minutes)")
                            }
                            
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text(scheduledDate.location)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // Action buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            onDecline()
                        }) {
                            Label("Decline", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        
                        Button(action: {
                            onAccept()
                        }) {
                            Label("Accept Date", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    .padding(.vertical)
                }
                .padding()
            }
            .navigationTitle("Match Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PartnerProfileView(
        partner: User(
            name: "Jane Smith",
            age: 26,
            bio: "Love hiking, reading, and coffee shop conversations. Looking for genuine connection."
        ),
        match: Match(
            user1Id: UUID(),
            user2Id: UUID(),
            similarityScore: 87.5,
            scheduledDate: ScheduledDate(
                location: "Central Park Café",
                dateTime: Date()
            )
        ),
        onAccept: {},
        onDecline: {}
    )
}
