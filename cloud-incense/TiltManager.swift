import Foundation
import Observation
#if os(iOS)
import CoreMotion
import UIKit
#endif

/// Wraps CoreMotion device motion and provides low-pass-filtered, clamped
/// screen-coordinate-based tilt values for driving smoke drift.
/// Maps device gravity vectors to screen coordinates across all device orientations.
/// On platforms without a motion sensor (macOS) all values remain 0.
@Observable
final class TiltManager {
    /// Screen-space horizontal tilt: negative = tilt left, positive = tilt right
    private(set) var horizontalTilt: Double = 0   // radians, clamped to ±maxTilt
    /// Screen-space vertical tilt: negative = tilt away, positive = tilt toward user
    private(set) var verticalTilt: Double = 0     // radians, clamped to ±maxTilt
    
    // Backwards compatibility aliases for roll/pitch
    var roll: Double { horizontalTilt }
    var pitch: Double { verticalTilt }

    static var isSupported: Bool {
        #if os(iOS)
        return CMMotionManager().isDeviceMotionAvailable
        #else
        return false
        #endif
    }

    /// Low-pass filter weight: 0=frozen (no update), 1=raw (no filtering).
    /// Default 0.12 provides smooth motion with good responsiveness.
    var filterAlpha: Double = 0.12
    
    /// Maximum tilt angle in radians before clamping. Default 0.5 ≈ 28.6°.
    /// Prevents extreme offsets and jerky particle behavior.
    var maxTilt: Double = 0.5

    #if os(iOS)
    private let motion = CMMotionManager()
    #endif

    func start() {
        #if os(iOS)
        guard Self.isSupported, !motion.isDeviceMotionActive else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 20  // 20 Hz – sufficient for smoke drift
        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            // Get gravity vector and current device orientation
            let gravity = data.gravity
            let orientation = UIDevice.current.orientation
            
            // Map gravity vector to screen coordinates based on device orientation
            let (horizontal, vertical) = self.mapGravityToScreenCoordinates(
                gravity: gravity,
                orientation: orientation
            )
            
            // Low-pass filter for smooth motion
            self.horizontalTilt = self.filterAlpha * horizontal + (1 - self.filterAlpha) * self.horizontalTilt
            self.verticalTilt = self.filterAlpha * vertical + (1 - self.filterAlpha) * self.verticalTilt
            
            // Clamp to prevent extreme offsets
            self.horizontalTilt = max(-self.maxTilt, min(self.maxTilt, self.horizontalTilt))
            self.verticalTilt = max(-self.maxTilt, min(self.maxTilt, self.verticalTilt))
        }
        #endif
    }

    func stop() {
        #if os(iOS)
        guard motion.isDeviceMotionActive else { return }
        motion.stopDeviceMotionUpdates()
        #endif
        // Smoothly return to neutral
        horizontalTilt = 0
        verticalTilt = 0
    }
    
    // MARK: - Gravity Mapping (Device→Screen Coordinates)
    
    /// Mapping table for converting device coordinates to screen coordinates.
    /// Documents the transformation rules for each orientation.
    private struct OrientationMapping {
        let name: String
        let description: String
        /// How to transform X: "gravity.x" or "-gravity.y" etc.
        let screenHorizontalFormula: String
        /// How to transform Y: "gravity.y" or "gravity.x" etc.
        let screenVerticalFormula: String
    }
    
    private static let orientationMappings: [UIDeviceOrientation: OrientationMapping] = [
        .portrait: OrientationMapping(
            name: "portrait",
            description: "Device upright, screen normal",
            screenHorizontalFormula: "gravity.x",
            screenVerticalFormula: "gravity.y"
        ),
        .portraitUpsideDown: OrientationMapping(
            name: "portraitUpsideDown",
            description: "Device inverted",
            screenHorizontalFormula: "-gravity.x",
            screenVerticalFormula: "-gravity.y"
        ),
        .landscapeRight: OrientationMapping(
            name: "landscapeRight",
            description: "Device rotated 90° clockwise (home button right)",
            screenHorizontalFormula: "-gravity.y",
            screenVerticalFormula: "gravity.x"
        ),
        .landscapeLeft: OrientationMapping(
            name: "landscapeLeft",
            description: "Device rotated 90° counter-clockwise (home button left)",
            screenHorizontalFormula: "gravity.y",
            screenVerticalFormula: "-gravity.x"
        ),
    ]
    
    /// Maps gravity vector to screen-space tilt values based on device orientation.
    /// Uses gravity vector for stability across orientation changes.
    /// Returns (horizontal, vertical) in screen coordinates:
    ///   - horizontal: +right, -left (affects smoke drift)
    ///   - vertical: +toward, -away (typically for features, but smoke uses always-up)
    #if os(iOS)
    private func mapGravityToScreenCoordinates(
        gravity: CMAcceleration,
        orientation: UIDeviceOrientation
    ) -> (Double, Double) {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            // Portrait: gravity X directly maps to horizontal tilt
            // Positive X (right) = positive tilt
            let horizontal = gravity.x
            let vertical = gravity.y  // downward tilt
            return (horizontal, vertical)
            
        case .landscapeRight:
            // Device rotated 90° clockwise (viewed from above)
            // Screen X was device -Y, Screen Y was device X
            let horizontal = -gravity.y
            let vertical = gravity.x
            return (horizontal, vertical)
            
        case .landscapeLeft:
            // Device rotated 90° counter-clockwise
            // Screen X was device Y, Screen Y was device -X
            let horizontal = gravity.y
            let vertical = -gravity.x
            return (horizontal, vertical)
            
        case .faceUp, .faceDown, .unknown:
            // Fallback for unusual orientations
            return (gravity.x, gravity.y)

        @unknown default:
            // Future-proof for any new UIDeviceOrientation cases.
            return (gravity.x, gravity.y)
        }
    }
    #endif
}
