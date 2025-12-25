# Friends Dating App

A marriage-focused iOS dating app built with SwiftUI that uses social psychology principles to create meaningful connections.

## Overview

Friends is a unique dating platform that prioritizes similarity in interests and personality to predict attraction and compatibility. Unlike traditional swiping apps, Friends uses an AI-powered matching system based on scientific research in social psychology.

## Key Features

### No Swiping
- AI suggests 3 carefully selected matches per week
- Quality over quantity approach
- Reduces decision fatigue and promotes thoughtful connections

### Scientific Matching Algorithm
- 50-question personality and interests quiz
- 5-point Likert scale (Strongly Disagree to Strongly Agree)
- Weighted scoring system:
  - Strongly Agree/Disagree: 5 points
  - Agree/Disagree: 3 points  
  - Neutral: 1 point
- Factors considered:
  - Personality traits compatibility
  - Shared interests and values
  - Age compatibility
  - Physical attraction (from photos)

### Automated Date Scheduling
- 30-minute first dates scheduled automatically
- Location and time based on user preferences
- Both users see profiles only after matching
- Simple yes/no to accept or decline dates

### Periodic Updates
- Quiz refreshes every 30 days to reflect personal growth
- Preferences can be updated anytime
- Keeps matches relevant and accurate

## Technical Architecture

### Models
- **User**: Profile information, photos, quiz responses, preferences
- **Quiz**: 50 questions across 4 categories (personality, interests, values, relationships)
- **Match**: Similarity scoring, match status, scheduled dates
- **ScheduledDate**: Date/time, location, 30-minute duration

### Services
- **MatchingService**: AI-powered matching algorithm with similarity calculation
- **DateSchedulingService**: Automatic scheduling based on mutual availability

### Views (SwiftUI)
- **QuizView**: Interactive 50-question quiz with progress tracking
- **MatchesView**: Weekly match display with accept/decline options
- **ProfileView**: User profile management and photo upload
- **PartnerProfileView**: View matched user's profile
- **SettingsView**: Preferences and quiz management

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
FriendsDatingApp/
├── Models/
│   ├── User.swift
│   ├── Quiz.swift
│   └── Match.swift
├── Views/
│   ├── ContentView.swift
│   ├── QuizView.swift
│   ├── MatchesView.swift
│   ├── ProfileView.swift
│   ├── PartnerProfileView.swift
│   ├── PreferencesEditView.swift
│   └── SettingsView.swift
├── ViewModels/
│   ├── QuizViewModel.swift
│   ├── ProfileViewModel.swift
│   └── MatchViewModel.swift
└── Services/
    ├── MatchingService.swift
    └── DateSchedulingService.swift
```

## Building the App

This project uses Xcode:

1. Open `FriendsDatingApp.xcodeproj` in Xcode
2. Select an iOS simulator or connected device
3. Build and run (⌘+R)

To run tests:
- Press ⌘+U in Xcode
- Or select Product > Test from menu

## How It Works

1. **Onboarding**: Users complete a comprehensive 50-question quiz
2. **Matching**: AI analyzes responses weekly to find the top 3 most compatible matches
3. **Scheduling**: System automatically schedules 30-minute dates based on preferences
4. **Review**: Users see matched profiles and can accept or decline dates
5. **Connection**: Accepted dates are confirmed when both users agree
6. **Update**: Quiz updates every 30 days; preferences changeable anytime

## Privacy & Safety

- Profiles shown only after mutual matching
- No swiping or endless browsing
- Focus on serious, marriage-minded individuals
- User preferences respected in all matches

## Future Enhancements

- Backend integration for data persistence
- Real-time notifications for new matches
- In-app messaging after date confirmation
- Photo verification and moderation
- Location-based matching with distance calculation
- Date feedback and match refinement
- Video profile introductions

## License

Copyright © 2024 Friends Dating App. All rights reserved.