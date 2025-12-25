import SwiftUI

/// View for editing user preferences
public struct PreferencesEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var preferences: UserPreferences
    let onSave: (UserPreferences) -> Void
    
    public init(preferences: UserPreferences, onSave: @escaping (UserPreferences) -> Void) {
        _preferences = State(initialValue: preferences)
        self.onSave = onSave
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section("Age Range") {
                    HStack {
                        Text("Min")
                        Spacer()
                        TextField("Min", value: $preferences.ageRangeMin, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    
                    HStack {
                        Text("Max")
                        Spacer()
                        TextField("Max", value: $preferences.ageRangeMax, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                }
                
                Section("Location") {
                    HStack {
                        Text("Max Distance")
                        Spacer()
                        TextField("Miles", value: $preferences.maxDistance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("miles")
                    }
                    
                    NavigationLink("Preferred Locations") {
                        LocationsEditView(locations: $preferences.preferredLocations)
                    }
                }
                
                Section("Availability") {
                    NavigationLink("Available Days") {
                        AvailableDaysView(selectedDays: $preferences.availableDays)
                    }
                    
                    NavigationLink("Time Slots") {
                        TimeSlotsView(timeSlots: $preferences.availableTimeSlots)
                    }
                }
            }
            .navigationTitle("Edit Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(preferences)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LocationsEditView: View {
    @Binding var locations: [String]
    @State private var newLocation = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Add location", text: $newLocation)
                    Button("Add") {
                        if !newLocation.isEmpty {
                            locations.append(newLocation)
                            newLocation = ""
                        }
                    }
                }
            }
            
            Section("Your Locations") {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
                .onDelete { indexSet in
                    locations.remove(atOffsets: indexSet)
                }
            }
        }
        .navigationTitle("Locations")
    }
}

struct AvailableDaysView: View {
    @Binding var selectedDays: Set<Weekday>
    
    var body: some View {
        List {
            ForEach(Weekday.allCases, id: \.self) { day in
                Button(action: {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                }) {
                    HStack {
                        Text(day.rawValue.capitalized)
                        Spacer()
                        if selectedDays.contains(day) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Available Days")
    }
}

struct TimeSlotsView: View {
    @Binding var timeSlots: [TimeSlot]
    @State private var showingAdd = false
    
    var body: some View {
        List {
            ForEach(timeSlots, id: \.self) { slot in
                VStack(alignment: .leading) {
                    Text(slot.day.rawValue.capitalized)
                        .font(.headline)
                    Text("\(slot.startHour):00 - \(slot.endHour):00")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .onDelete { indexSet in
                timeSlots.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Time Slots")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAdd = true
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddTimeSlotView { slot in
                timeSlots.append(slot)
                showingAdd = false
            }
        }
    }
}

struct AddTimeSlotView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDay: Weekday = .monday
    @State private var startHour = 9
    @State private var endHour = 17
    let onAdd: (TimeSlot) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Day", selection: $selectedDay) {
                    ForEach(Weekday.allCases, id: \.self) { day in
                        Text(day.rawValue.capitalized).tag(day)
                    }
                }
                
                Picker("Start Hour", selection: $startHour) {
                    ForEach(0..<24) { hour in
                        Text("\(hour):00").tag(hour)
                    }
                }
                
                Picker("End Hour", selection: $endHour) {
                    ForEach(0..<24) { hour in
                        Text("\(hour):00").tag(hour)
                    }
                }
            }
            .navigationTitle("Add Time Slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let slot = TimeSlot(day: selectedDay, startHour: startHour, endHour: endHour)
                        onAdd(slot)
                    }
                }
            }
        }
    }
}

#Preview {
    PreferencesEditView(preferences: UserPreferences()) { _ in }
}
