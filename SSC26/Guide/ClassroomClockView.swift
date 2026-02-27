import SwiftUI

import SwiftUI
import Combine

/// A decorative classroom wall clock
/// Positioned in the corner to enhance the scholastic atmosphere
struct ClassroomClockView: View {
    @State private var currentTime = Date()
    
    // Timer to update clock hands
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Clock frame shadow (reduced depth)
            Circle()
                .fill(Color.black.opacity(0.08))
                .blur(radius: 4)
                .offset(x: 1, y: 2)
            
            // Clock frame (refined bezel with softer edge - lighter charcoal)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.30, blue: 0.32),
                            Color(red: 0.25, green: 0.25, blue: 0.27)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
            
            // Clock face (white with softer edge)
            Circle()
                .fill(Color.white)
                .frame(width: 72, height: 72)
            
            // Soft inner shadow for depth
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.black.opacity(0.02),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    ),
                    lineWidth: 3
                )
                .frame(width: 72, height: 72)
            
            // Clock numbers (12, 3, 6, 9)
            Text("12")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.7))
                .offset(y: -28)
            
            Text("3")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.7))
                .offset(x: 28)
            
            Text("6")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.7))
                .offset(y: 28)
            
            Text("9")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color.black.opacity(0.7))
                .offset(x: -28)
            
            // Hour markers (dots for other hours, excluding 12, 3, 6, 9)
            ForEach([1, 2, 4, 5, 7, 8, 10, 11], id: \.self) { hour in
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 3, height: 3)
                    .offset(y: -28)
                    .rotationEffect(.degrees(Double(hour) * 30))
            }
            
            // Hour hand
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.black.opacity(0.8))
                .frame(width: 3, height: 16)
                .offset(y: -8)
                .rotationEffect(hourAngle)
            
            // Minute hand
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.black.opacity(0.8))
                .frame(width: 2, height: 24)
                .offset(y: -12)
                .rotationEffect(minuteAngle)
            
            // Center pin
            Circle()
                .fill(Color.black)
                .frame(width: 6, height: 6)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    private var hourAngle: Angle {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime) % 12
        let minute = calendar.component(.minute, from: currentTime)
        let degrees = Double(hour) * 30 + Double(minute) * 0.5
        return .degrees(degrees)
    }
    
    private var minuteAngle: Angle {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: currentTime)
        return .degrees(Double(minute) * 6)
    }
}

#Preview {
    ClassroomClockView()
        .frame(width: 80, height: 80)    
}
