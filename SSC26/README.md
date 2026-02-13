# XyloFingers 🎵

**An interactive xylophone app that brings music to your fingertips — literally!**

XyloFingers is an iPadOS application that transforms your device into a magical musical instrument. Using innovative hand tracking technology powered by Vision framework, users can play a virtual xylophone through intuitive gestures or traditional touch input.

## Project Overview

XyloFingers combines music education, gesture recognition, and delightful user experience design to create an engaging way for users of all ages to explore music-making on iPad.

### The Core Idea

The app reimagines how we interact with digital musical instruments by offering two distinct modes of play:

1. **Touch Mode** - Traditional tap-to-play interaction, perfect for beginners and quick sessions
2. **Hand Tracking Mode** - Advanced gesture control using the iPad's front-facing camera to detect hand movements and pinch gestures

This dual-mode approach makes XyloFingers both accessible and innovative, allowing users to choose the interaction style that suits them best.

## Key Features

### 🎹 Interactive Xylophone
- Full xylophone with colorful bars arranged in musical scale order
- Visual feedback when notes are played
- High-quality audio samples for authentic sound

### 👋 Hand Tracking Technology
- Real-time hand detection using Apple's Vision framework
- Recognizes thumb and index finger positions
- Pinch gesture detection to trigger notes
- Visual indicators (colored dots) showing finger tracking status
- Distance-based interaction for natural, spatial play

### 🎼 Two Play Modes

#### **Free Play Mode**
- Open-ended musical exploration
- No rules, just creativity
- Perfect for experimentation and improvisation

#### **Guided Practice Mode**
- Learn popular songs step-by-step
- Follow highlighted notes to play melodies
- Progress tracking as you complete songs
- Difficulty levels (Level 1, Level 2, Level 3)
- Built-in song library with classics and familiar tunes

### 📖 Interactive Guide
- Comprehensive onboarding experience
- Step-by-step hand tracking tutorial
- Quick action cards for different features
- Pro tips for optimal performance
- In-app toggle to switch between interaction modes

## Technical Architecture

### Technologies Used

- **SwiftUI** - Modern declarative UI framework for all views and interactions
- **Vision Framework** - Hand pose detection and tracking
- **AVFoundation** - Audio playback for xylophone notes
- **Swift Concurrency** - Async/await patterns for camera and audio processing
- **Observation Framework** - Modern state management with `@Observable`

### Core Components

#### Hand Tracking System
The hand tracking implementation uses Vision's `VNDetectHumanHandPoseRequest` to:
- Capture video frames from the front-facing camera
- Detect hand landmarks (21 points per hand)
- Calculate pinch distance between thumb and index finger
- Map hand positions to screen coordinates
- Trigger note playback when pinch gesture is detected

#### Audio Engine
- Pre-loaded audio samples for each xylophone note
- Low-latency playback for responsive interaction
- Support for simultaneous note triggering

#### State Management
- Centralized `AppSettings` using `@Observable` for global preferences
- View-specific state for UI interactions
- Binding patterns for seamless hand tracking toggle

## User Experience Design

### Visual Design
- **Gradient backgrounds** that create an immersive, playful atmosphere
- **Colorful xylophone bars** with distinct colors for easy note identification
- **Glass morphism effects** using semi-transparent cards with soft shadows
- **Smooth animations** using SwiftUI's spring animations
- **Dark mode support** with adaptive colors for all lighting conditions

### Accessibility
- Clear visual feedback for all interactions
- Large touch targets for easy interaction
- Text alternatives for icons
- Color-blind friendly color palettes
- Support for both touch and gesture input methods

## Target Audience

- **Music enthusiasts** looking for a fun, casual instrument
- **Children** learning basic music concepts and coordination
- **Educators** teaching music fundamentals in an interactive way
- **Technology enthusiasts** exploring gesture-based interfaces
- **Anyone** who wants to make music in a playful, accessible way

## Future Enhancement Ideas

- 🎵 Recording and playback functionality
- 📱 Share compositions with friends
- 🎮 Gamification with scoring and challenges
- 🎨 Customizable xylophone themes and sounds
- 👥 Multi-hand tracking for collaborative play
- 🌍 Community song library with user-created content
- 📊 Progress tracking and achievement system

## Project Philosophy

XyloFingers is built on the principle that music creation should be:

- **Joyful** - Making music should bring delight, not frustration
- **Accessible** - Everyone should be able to play, regardless of musical training
- **Innovative** - Technology can enhance traditional instruments in meaningful ways
- **Educational** - Learning music should be engaging and interactive
- **Inclusive** - Multiple interaction methods ensure everyone can participate

## Platform Requirements

- **iPadOS 16.0+** - Required for Vision hand tracking features
- **iPad with front-facing camera** - For hand tracking mode
- **Recommended**: iPad Pro or iPad Air for optimal camera performance

---

**XyloFingers** - Where technology meets melody, one pinch at a time! 🎶✨
