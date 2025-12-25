# Getting Started with Friends Dating App

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 16.0+ device or simulator

## Opening the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/willpiot/friends-dating-app.git
   cd friends-dating-app
   ```

2. Open the project in Xcode:
   ```bash
   open FriendsDatingApp.xcodeproj
   ```
   
   Or simply double-click `FriendsDatingApp.xcodeproj` in Finder.

3. Select a simulator or connected device from the scheme selector in Xcode.

4. Press `⌘ + R` to build and run the app.

## Project Structure

```
FriendsDatingApp/
├── FriendsDatingApp/
│   ├── FriendsDatingApp.swift      # App entry point
│   ├── Models/                      # Data models
│   │   ├── User.swift              # User profile and preferences
│   │   ├── Quiz.swift              # 50-question quiz system
│   │   └── Match.swift             # Matching and scheduling
│   ├── Views/                       # SwiftUI views
│   │   ├── ContentView.swift       # Main navigation
│   │   ├── QuizView.swift          # Quiz interface
│   │   ├── MatchesView.swift       # Weekly matches display
│   │   ├── ProfileView.swift       # User profile
│   │   ├── PartnerProfileView.swift # Matched partner profile
│   │   ├── PreferencesEditView.swift # Edit preferences
│   │   └── SettingsView.swift      # App settings
│   ├── ViewModels/                  # State management
│   │   ├── QuizViewModel.swift
│   │   ├── ProfileViewModel.swift
│   │   └── MatchViewModel.swift
│   ├── Services/                    # Business logic
│   │   ├── MatchingService.swift   # AI matching algorithm
│   │   └── DateSchedulingService.swift # Date scheduling
│   ├── Assets.xcassets/            # Images and colors
│   └── Info.plist                  # App configuration
├── FriendsDatingAppTests/          # Unit tests
└── README.md                        # Project documentation
```

## Running Tests

1. In Xcode, press `⌘ + U` to run all tests
2. Or use Test Navigator (`⌘ + 6`) to run specific tests

## Key Features to Test

1. **Onboarding Quiz**
   - Complete the 50-question personality assessment
   - Test different response patterns
   - Verify quiz progress tracking

2. **Matching System**
   - Review similarity calculation algorithm
   - Check age compatibility filtering
   - Verify top 3 weekly matches

3. **Date Scheduling**
   - Configure availability preferences
   - Add preferred locations
   - Review automatically scheduled dates

4. **Profile Management**
   - Update user preferences
   - Retake quiz after 30 days
   - Manage photo uploads (UI only)

## Development Notes

### Current Implementation

This is a complete SwiftUI implementation with:
- All core models and business logic
- Full UI flow from onboarding to matching
- Comprehensive unit tests
- Clean architecture (MVVM pattern)

### What's Missing (Production Features)

- Backend API integration
- Real photo upload/storage
- Push notifications
- Real-time messaging
- User authentication
- Database persistence
- Location services integration
- Advanced photo analysis for physical attraction scoring

### Testing in Simulator

The app currently uses mock data for demonstration. To test:

1. Launch the app - you'll see the quiz
2. Complete all 50 questions
3. Navigate to Matches tab to see potential matches (will be empty without backend)
4. Edit preferences in Settings
5. Update your profile information

## Troubleshooting

### Build Errors

If you encounter build errors:
1. Clean build folder: `⌘ + Shift + K`
2. Close and reopen Xcode
3. Verify you're using Xcode 15.0+

### Simulator Issues

If the simulator doesn't launch:
1. Reset simulator: Device → Erase All Content and Settings
2. Restart Xcode
3. Try a different simulator device

## Next Steps for Production

1. **Backend Integration**
   - User authentication (Firebase, Auth0, or custom)
   - Database for user profiles and matches
   - Cloud storage for photos
   - API for matching algorithm

2. **Enhanced Features**
   - Push notifications for new matches
   - In-app chat after mutual acceptance
   - Video profile introductions
   - Date feedback system
   - Location-based matching

3. **Photo Verification**
   - AI-powered photo moderation
   - Liveness detection
   - Photo quality assessment

4. **Analytics**
   - User engagement tracking
   - Match success rates
   - A/B testing for quiz questions

## Contributing

When contributing to this project:
1. Follow Swift style guidelines
2. Maintain MVVM architecture
3. Add unit tests for new features
4. Update documentation

## Support

For questions or issues:
1. Check existing documentation
2. Review unit tests for usage examples
3. Open an issue on GitHub
