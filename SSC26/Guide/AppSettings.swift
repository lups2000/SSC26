import SwiftUI

@MainActor
@Observable
final class AppSettings {
    static let shared = AppSettings()
    
    var isHandTrackingEnabled: Bool = true
    
    private init() {}
}
