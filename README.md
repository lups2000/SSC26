# 🎵 XyloFingers

## ✨ Overview
**XyloFingers** transforms the iPad into a **spatial musical instrument**, allowing users to play a xylophone using either touch or **mid-air hand gestures**.

Inspired by spatial computing and devices like Apple Vision Pro, this project explores how we can bring **controller-free, immersive interaction** to a standard iPad, making music creation feel physical, expressive, and intuitive.

## 🚀 The Idea

Traditional digital instruments feel limited by the flatness of touchscreens.  
XyloFingers solves this by introducing:

- 🖐️ **Hand Tracking Mode** — play notes in mid-air using pinch gestures  
- 👆 **Touch Mode** — a familiar and precise fallback  
- 🎯 **Guided Practice Mode** — learn rhythm and timing interactively  

**Goal:** Make a digital instrument feel as natural and expressive as a real one.

## 🏁 Swift Student Challenge 2026

This project was created for the **Swift Student Challenge 2026**.  
While it was **not selected as a winning submission**, it represents a project I’m genuinely proud of—both technically and creatively.

Building XyloFingers allowed me to explore **spatial interaction, real-time systems, and accessibility-driven design**, and it continues to serve as a foundation for future ideas.

## 🛠️ Tech Stack

### 🎨 SwiftUI + Observation
- Declarative UI for smooth updates  
- Fine-grained rendering with `@Observable`  

### 👁️ Vision Framework
- Real-time hand tracking (`VNDetectHumanHandPoseRequest`)  
- On-device processing for privacy and performance  

### ⚡ Swift Concurrency
- `async/await` for non-blocking processing  
- `@MainActor` for safe UI updates  

### 🔊 AVFoundation
- Low-latency audio playback  
- Preloaded buffers for instant feedback
