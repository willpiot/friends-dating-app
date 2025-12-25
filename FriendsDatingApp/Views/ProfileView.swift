import SwiftUI

/// View for displaying and editing user profile
public struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile photo
                    if viewModel.user.photos.isEmpty {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .foregroundColor(.gray)
                    }
                    
                    Button("Add Photo") {
                        // In production, implement photo picker
                        viewModel.addPhoto("photo_\(viewModel.user.photos.count + 1)")
                    }
                    .buttonStyle(.bordered)
                    
                    // Basic info
                    VStack(alignment: .leading, spacing: 15) {
                        InfoRow(label: "Name", value: viewModel.user.name)
                        InfoRow(label: "Age", value: "\(viewModel.user.age)")
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Bio")
                                .font(.headline)
                            Text(viewModel.user.bio)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Quiz status
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quiz Status")
                            .font(.headline)
                        
                        if let responses = viewModel.user.quizResponses {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Completed")
                                Spacer()
                                if viewModel.user.needsQuizUpdate {
                                    Text("Update Available")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            Text("Last updated: \(viewModel.user.lastQuizUpdate, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.orange)
                                Text("Not completed")
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Preferences summary
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Preferences")
                                .font(.headline)
                            Spacer()
                            Button("Edit") {
                                viewModel.isEditingPreferences = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        InfoRow(label: "Age Range", value: "\(viewModel.user.preferences.ageRangeMin)-\(viewModel.user.preferences.ageRangeMax)")
                        InfoRow(label: "Max Distance", value: "\(Int(viewModel.user.preferences.maxDistance)) miles")
                        InfoRow(label: "Locations", value: "\(viewModel.user.preferences.preferredLocations.count) selected")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding()
            }
            .navigationTitle("My Profile")
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

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(user: User(
        name: "John Doe",
        age: 28,
        bio: "Looking for meaningful connections"
    )))
}
