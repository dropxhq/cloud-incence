# Smoke & Live Activity Optimization - Testing Checklist

## 5.1 Degradation Verification

### Devices WITHOUT Live Activity Support (iOS < 16.2)

- [ ] App runs without crashes when starting\stopping burn on iOS < 16.2
- [ ] BurnActivityService methods are no-ops (no exceptions)
- [ ] Smoke animation and tilt interaction work normally  
- [ ] Prayer text input/display works in main app
- [ ] No UI elements crash when Live Activity features missing
- [ ] Notifications still functional for burn complete

### Devices WITH Live Activity but NO Motion Sensors (iPad, Simulator)

- [ ] Live Activity displays correctly on lock screen
- [ ] TiltManager.isSupported returns false
- [ ] Smoke animation plays without tilt (uses default motion)
- [ ] Progress bar in Live Activity updates normally
- [ ] Prayer summary displays correctly truncated
- [ ] No motion data errors or warnings in console

### Devices WITH Both Live Activity AND Motion Sensors (iPhone)

- [ ] All features above work + tilt interaction active
- [ ] Smoke responds to device tilt in all orientations  
- [ ] Progress bar updates smoothly
- [ ] Prayer summary displays with correct truncation

## 5.2 Orientation & Background/Foreground Testing

### Portrait Orientation

- [ ] Device held upright
  - Tilt LEFT: Smoke drifts LEFT ✓
  - Tilt RIGHT: Smoke drifts RIGHT ✓
  - Smoke always rises upward ✓
- [ ] Live Activity shows correct progress ✓
- [ ] Prayer summary visible and truncated properly ✓

### Landscape Right (Home Button Right)

- [ ] Device rotated 90° clockwise  
  - Tilt toward user: Smoke drifts RIGHT ✓
  - Tilt away: Smoke drifts LEFT ✓  
  - Smoke always rises upward ✓
- [ ] Live Activity adapts to landscape layout ✓
- [ ] Progress bar scales properly ✓
- [ ] Prayer text remains readable ✓

### Landscape Left (Home Button Left)

- [ ] Device rotated 90° counter-clockwise
  - Tilt toward user: Smoke drifts LEFT ✓
  - Tilt away: Smoke drifts RIGHT ✓
  - Smoke always rises upward ✓
- [ ] Live Activity adapts to landscape layout ✓  
- [ ] No visual anomalies ✓

### Background/Foreground Switching

- [ ] App in foreground: All features work normally ✓
- [ ] Switch to background:
  - Burn session pauses/continues (per design)
  - Live Activity continues updating
  - No crashes on return to foreground
- [ ] Lock screen remains updated during background ✓
- [ ] Prayer summary persists across background switch ✓

### Orientation Changes During Burn

- [ ] Start in portrait, rotate to landscape left
  - Smoke direction remaps correctly
  - No visual jarring or smoke "jumping"
- [ ] Rotate between landscape left/right
  - Direction mapping consistent
  - Smoke continues upward motion
- [ ] Rotate back to portrait
  - No artifacts or lag
  - Smoke animation smooth throughout

## 5.3 Live Activity State Synchronization

- [ ] on Initial Start:
  - Live Activity created with correct startDate
  - prayerSummary populated from BurnSession.prayerText
  - Phase set to "燃烧中"
  - endDate matches expected 21-minute burn

- [ ] During Burn:
  - Progress updates every second (or as frequent as ActivityKit allows)
  - Live Activity visible on lock screen/dynamic island
  - Compact view shows percentage
  - Expanded view shows progress bar
  - Prayer summary remains stable

- [ ] On Completion:
  - Phase changes to "已完成"  
  - Live Activity shows completion state
  - Dismisses after 10 seconds per design
  - prayerSummary still visible during completion

- [ ] State Field Synchronization:
  - App model (BurnActivityAttributes in main app)
  - Widget model (BurnActivityAttributes in widget extension)
  - Both have identical field definitions
  - No field drift between targets

## Known Issues & Notes

- Prayer summary limited to 60 chars (configured in BurnActivityService)
- Dynamic Island display adapts: expanded uses full progress bar, compact uses %-only  
- Smoke emission angle constrained to 0.05 rad to prevent visual downward drift
- Maximum tilt clamp at 0.5 radians (~28.6°) to prevent extreme offsets

## Regression Checkpoints

### Critical Invariants to Verify

1. **Smoke Always Rises**: No orientation or tilt angle should cause smoke to visually drift downward
2. **Progress Accuracy**: Live Activity progress matches elapsed time (within 1-2% tolerance)
3. **Prayer Display**: Truncation works for various text lengths without crashes
4. **State Sync**: No UI crashes when syncing new startDate/prayerSummary fields
