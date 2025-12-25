# Friends Dating App - Technical Architecture

## Overview

Friends is built using SwiftUI and follows the MVVM (Model-View-ViewModel) architectural pattern for clean separation of concerns and testability.

## Architecture Layers

### 1. Models (Data Layer)

**User.swift**
- Represents user profiles with personal information
- Stores quiz responses and preferences
- Tracks quiz update schedule (30-day cycle)
- Codable for data persistence

**Quiz.swift**
- Defines 50-question personality/interests assessment
- Implements 5-point Likert scale with weighted scoring:
  - Strongly Agree/Disagree: 5 points
  - Agree/Disagree: 3 points
  - Neutral: 1 point
- Categorizes questions: personality, interests, values, relationships

**Match.swift**
- Stores match information between two users
- Calculates similarity scores (0-100)
- Manages scheduled dates with location/time
- Tracks match status (pending, accepted, declined, completed)

### 2. ViewModels (Presentation Logic)

**QuizViewModel**
- Manages quiz state and progression
- Tracks user responses
- Calculates completion percentage
- Provides quiz data to views

**ProfileViewModel**
- Manages user profile state
- Handles preference updates
- Controls photo management
- Triggers quiz updates

**MatchViewModel**
- Manages weekly match list
- Handles match acceptance/decline
- Loads partner profiles
- Coordinates with matching service

### 3. Services (Business Logic)

**MatchingService**
- Implements AI-powered matching algorithm
- Filters candidates by preferences:
  - Age range compatibility
  - Mutual age acceptance
  - Quiz completion status
- Calculates similarity using weighted quiz responses
- Factors in:
  - Personality/interest similarity (80%)
  - Age compatibility (10%)
  - Physical attraction (10%)
- Returns top 3 matches weekly

**DateSchedulingService**
- Finds common availability between matched users
- Selects optimal time slots from preferences
- Schedules 30-minute dates automatically
- Chooses location based on mutual preferences

### 4. Views (UI Layer)

**ContentView**
- Main app navigation with TabView
- Three tabs: Matches, Profile, Settings
- Handles quiz presentation
- Manages app-wide state

**QuizView**
- Interactive quiz interface
- Progress tracking
- Likert scale selection
- Question navigation

**MatchesView**
- Displays weekly matches
- Shows similarity scores
- Presents scheduled date details
- Accept/decline interface

**PartnerProfileView**
- Shows matched user's profile
- Displays compatibility score
- Presents date details
- Provides acceptance controls

**ProfileView**
- User profile display
- Photo management
- Quiz status
- Preference summary

**PreferencesEditView**
- Age range configuration
- Location preferences
- Availability scheduling
- Time slot management

**SettingsView**
- Quiz retake option
- Preference editing
- App information
- Account management

## Data Flow

```
User Interaction
    ↓
View (SwiftUI)
    ↓
ViewModel (ObservableObject)
    ↓
Service/Model (Business Logic)
    ↓
Model (Data Update)
    ↓
ViewModel (Published Property)
    ↓
View (UI Update)
```

## Matching Algorithm

### Similarity Calculation

1. **Quiz Response Comparison**
   ```swift
   For each of 50 questions:
     - Compare user responses (1-5 scale)
     - Calculate difference (0-4)
     - Compute similarity: 1 - (difference / 4)
     - Weight by response strength (1, 2, 3, or 5 points)
     - Accumulate weighted similarity
   
   Quiz Score = (Total Weighted Similarity / Max Possible) × 100
   ```

2. **Age Compatibility**
   ```swift
   Age Difference = |User1.age - User2.age|
   Age Score = max(0, 100 - (Age Difference × 5))
   ```

3. **Physical Attraction**
   - Currently simplified (50% baseline)
   - Production would use photo analysis AI

4. **Final Score**
   ```swift
   Final Score = (Quiz × 0.80) + (Age × 0.10) + (Physical × 0.10)
   ```

### Matching Process

1. Filter candidates:
   - Exclude self
   - Require completed quiz
   - Check age range (bidirectional)

2. Calculate similarity for each candidate

3. Sort by similarity (descending)

4. Select top 3 matches

5. Schedule dates for each match

## Date Scheduling Algorithm

### Time Slot Matching

1. Extract available time slots from both users
2. Find overlapping days
3. Calculate overlapping hours
4. Select random slot from common availability

### Location Selection

1. Find intersection of preferred locations
2. If common location exists, select randomly
3. Otherwise, use default locations:
   - Coffee Shop, Park, Restaurant, Café, Library

### Date Time Calculation

1. Map weekday to calendar weekday
2. Find next occurrence of selected day
3. Set time to slot start hour
4. If in past, advance by one week

## Testing Strategy

### Unit Tests

**QuizTests**
- Verify 50 questions in standard quiz
- Test Likert scale weights
- Validate quiz completion logic
- Check question categorization

**MatchingTests**
- Test similarity calculation accuracy
- Verify opposite responses yield low scores
- Ensure top 3 matches returned
- Test age filtering

**UserTests**
- Test user initialization
- Verify quiz update timing (30 days)
- Check preference defaults
- Validate time slot creation

**DateSchedulingTests**
- Test scheduled date creation
- Verify confirmation logic
- Test match status transitions
- Validate date scheduling with overlapping slots

### Integration Testing

- Quiz flow end-to-end
- Matching with multiple candidates
- Date scheduling workflow
- Profile updates and persistence

## State Management

### @StateObject vs @ObservedObject

- `@StateObject`: Used for ViewModels owned by the view
  - ContentView owns ProfileViewModel
  - QuizView owns QuizViewModel

- `@ObservedObject`: Used for ViewModels passed to child views
  - MatchesView receives MatchViewModel
  - ProfileView receives ProfileViewModel

### @Published Properties

All ViewModels use `@Published` for reactive updates:
- User profile changes
- Quiz responses
- Match list updates
- UI state changes

## Scalability Considerations

### Current Architecture Supports

- Local-first design
- Offline quiz completion
- Efficient matching algorithm (O(n) filtering, O(n log n) sorting)
- Modular code for easy testing

### Production Enhancements Needed

1. **Backend Integration**
   - RESTful API or GraphQL
   - User authentication
   - Cloud storage for photos
   - Real-time updates

2. **Caching Strategy**
   - Core Data for local persistence
   - Image caching for photos
   - Match result caching

3. **Performance**
   - Lazy loading for large user lists
   - Pagination for matches
   - Background processing for matching

4. **Security**
   - End-to-end encryption for messages
   - Secure photo storage
   - Data privacy compliance

## Code Quality

### Swift Best Practices

- Strong typing throughout
- Optionals for null safety
- Value types (structs) for immutable data
- Reference types (classes) for shared state

### MVVM Benefits

- Testable business logic
- Reusable ViewModels
- Clear separation of concerns
- Easy to modify views without affecting logic

### Documentation

- Inline comments for complex logic
- Public API documentation
- Architecture documentation (this file)
- Getting started guide
