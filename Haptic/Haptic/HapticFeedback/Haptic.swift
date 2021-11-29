//
//  Haptic.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import AudioToolbox
import UIKit

/// Девайсы, которые не поддерживают вибрации
private let devicesWithoutHapticEngine: Set<String> = [
    "iPhone6,1", // iPhone 5S
    "iPhone6,2", // iPhone 5S_China
    "iPhone7,1", // iPhone 6 Plus
    "iPhone7,2", // iPhone 6
    "iPhone8,1", // iPhone 6S
    "iPhone8,2"  // iPhone 6S Plus
]

public enum Haptic {
    case warning
    case error
    case success
    case light
    case medium
    case heavy
    case selection

    // MARK: - Private Properties

    private static let selectionGenerator = UISelectionFeedbackGenerator()
    private static let notificationGenerator = UINotificationFeedbackGenerator()
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)

    private static let isHapticEngineAvailable: Bool = {
        !devicesWithoutHapticEngine.contains(UIDevice.currentModelName)
    }()

    ///  Данный метод необходимо вызвать перед воспроизведением вибрации.
    ///  Система подготовит девайс к воспроизведению вибрации, что уменьшит задержку.
    func prepare() {
        guard Haptic.isHapticEngineAvailable else { return }

        switch self {
        case .error:
            Haptic.notificationGenerator.prepare()

        case .success:
            Haptic.notificationGenerator.prepare()

        case .warning:
            Haptic.notificationGenerator.prepare()

        case .light:
            Haptic.lightGenerator.prepare()

        case .medium:
            Haptic.mediumGenerator.prepare()

        case .heavy:
            Haptic.heavyGenerator.prepare()

        case .selection:
            Haptic.selectionGenerator.prepare()
        }
    }

    func generate() {
        guard Haptic.isHapticEngineAvailable else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }

        switch self {
        case .error:
            Haptic.notificationGenerator.notificationOccurred(.error)

        case .success:
            Haptic.notificationGenerator.notificationOccurred(.success)

        case .warning:
            Haptic.notificationGenerator.notificationOccurred(.warning)

        case .light:
            Haptic.lightGenerator.impactOccurred()

        case .medium:
            Haptic.mediumGenerator.impactOccurred()

        case .heavy:
            Haptic.heavyGenerator.impactOccurred()

        case .selection:
            Haptic.selectionGenerator.selectionChanged()
        }
    }
}
