import SpriteKit
import CoreGraphics

final class SmokeScene: SKScene {
    private var emitters: [SKEmitterNode] = []
    private var currentProgress: Double = 0
    
    /// Minimum upward acceleration to ensure smoke always rises.
    /// Prevents lateral forces from overwhelming upward motion.
    private let minUpwardAcceleration: CGFloat = 6.0
    
    /// Maximum lateral acceleration magnitude for horizontal drift.
    /// Constrains smoke disturbance to prevent extreme angles.
    private let maxLateralAcceleration: CGFloat = 15.0
    
    /// Maximum allowed emission angle range as a fraction of full variety.
    /// Smaller values = more consistent upward emission, larger = more variety.
    /// 0.05 radians ≈ 2.9° – minimal spread, ensures smoke emits nearly straight up.
    private let constrainedEmissionAngleRange: CGFloat = 0.05
    
    // MARK: - Visual Regression Checkpoints for Landscape Orientation
    // These scenarios should be visually verified during testing:
    // 1. LandscapeLeft + Tilt Left (maximum negative roll):
    //    Expected: Smoke drifts LEFT on screen, stays upward
    // 2. LandscapeLeft + Tilt Right (maximum positive roll):
    //    Expected: Smoke drifts RIGHT on screen, stays upward
    // 3. LandscapeRight + Tilt Left (maximum negative roll):
    //    Expected: Smoke drifts LEFT on screen, stays upward
    // 4. LandscapeRight + Tilt Right (maximum positive roll):
    //    Expected: Smoke drifts RIGHT on screen, stays upward
    //
    // Critical Invariant: Smoke MUST NOT appear to drift downward
    // in any orientation or tilt combination.
    override func didMove(to view: SKView) {
        guard emitters.isEmpty else { return }
        setupEmitters()
    }

    // MARK: - Public API

    func lightStick(at index: Int) {
        guard index < emitters.count else { return }
        emitters[index].particleBirthRate = 10
    }

    func updateProgress(_ progress: Double) {
        currentProgress = progress
        let positions = emitterPositions(for: progress)
        for (i, emitter) in emitters.enumerated() {
            emitter.position = positions[i]
        }
    }

    func extinguishAll() {
        emitters.forEach { $0.particleBirthRate = 0 }
    }

    /// Called from the main thread via SwiftUI onChange whenever filtered tilt changes.
    /// Maps screen-space horizontal tilt (-0.5…0.5 rad) to lateral particle acceleration.
    /// Keeps upward acceleration dominant to maintain "smoke always rises" invariant.
    func updateTilt(roll: Double, pitch: Double) {
        // Horizontal drift: positive roll (gravity right) = leftward drift (away from gravity)
        let xAccel = -CGFloat(roll * 45)
        let clampedXAccel = max(-maxLateralAcceleration, min(maxLateralAcceleration, xAccel))
        
        // Emission angle: keep it fixed (no angle offset based on tilt)
        // This ensures smoke consistently emits upward regardless of device angle
        let emissionAngle: CGFloat = .pi / 2  // Exactly straight up
        
        emitters.forEach {
            $0.xAcceleration = clampedXAccel
            $0.yAcceleration = minUpwardAcceleration  // Always maintain minimum upward force
            $0.emissionAngle = emissionAngle
        }
    }

    // MARK: - Setup

    private func setupEmitters() {
        let texture = makeCircleTexture(radius: 32)
        let positions = emitterPositions(for: 0)

        for i in 0..<3 {
            let e = makeSmokeEmitter(texture: texture)
            e.position = positions[i]
            addChild(e)
            emitters.append(e)
        }

        // Noise field for natural turbulence
        let noise = SKFieldNode.noiseField(withSmoothness: 0.5, animationSpeed: 0.5)
        noise.strength = 0.35
        addChild(noise)
    }

    private func emitterPositions(for progress: Double) -> [CGPoint] {
        let burnFraction = IncenseLayout.burnFraction(progress: progress)
        let centerTipY = IncenseLayout.holderHeight + IncenseLayout.centerStickHeight * burnFraction
        let sideTipY = IncenseLayout.holderHeight + IncenseLayout.sideStickHeight * burnFraction
        let stickCenterOffset = IncenseLayout.stickFrameWidth + IncenseLayout.stickSpacing
        return [
            CGPoint(x: -stickCenterOffset, y: sideTipY),   // left
            CGPoint(x: 0, y: centerTipY),                 // center
            CGPoint(x: stickCenterOffset, y: sideTipY),   // right
        ]
    }

    private func makeSmokeEmitter(texture: SKTexture) -> SKEmitterNode {
        let e = SKEmitterNode()
        e.particleTexture = texture
        e.particleBirthRate = 0
        e.particleLifetime = 4.5
        e.particleLifetimeRange = 2.0
        e.particlePositionRange = CGVector(dx: 3, dy: 0)
        e.particleSpeed = 32
        e.particleSpeedRange = 14
        e.emissionAngle = .pi / 2  // Straight up
        e.emissionAngleRange = constrainedEmissionAngleRange  // Minimal spread to ensure upward emission
        e.particleAlpha = 0.5
        e.particleAlphaRange = 0.2
        e.particleAlphaSpeed = -0.1
        e.particleScale = 0.1
        e.particleScaleRange = 0.04
        e.particleScaleSpeed = 0.035
        e.particleColor = SKColor(white: 0.9, alpha: 1)
        e.particleColorBlendFactor = 1.0
        e.particleBlendMode = .add
        e.yAcceleration = minUpwardAcceleration  // Ensure minimum upward acceleration
        return e
    }

    // Creates a soft radial-gradient circle texture for smoke particles
    private func makeCircleTexture(radius: CGFloat) -> SKTexture {
        let side = Int(radius * 2)
        let cs = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: nil,
            width: side, height: side,
            bitsPerComponent: 8, bytesPerRow: side * 4,
            space: cs,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        ) else { return SKTexture() }

        let colors = [CGColor(red: 1, green: 1, blue: 1, alpha: 1),
                      CGColor(red: 1, green: 1, blue: 1, alpha: 0)] as CFArray
        let locs: [CGFloat] = [0, 1]
        guard let gradient = CGGradient(colorsSpace: cs, colors: colors, locations: locs) else {
            return SKTexture()
        }
        let center = CGPoint(x: CGFloat(side) / 2, y: CGFloat(side) / 2)
        ctx.drawRadialGradient(
            gradient,
            startCenter: center, startRadius: 0,
            endCenter: center, endRadius: radius,
            options: [])

        guard let cgImage = ctx.makeImage() else { return SKTexture() }
        return SKTexture(cgImage: cgImage)
    }
}
