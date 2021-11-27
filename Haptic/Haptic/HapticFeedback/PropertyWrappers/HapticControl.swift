//
//  HapticControl.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import UIKit

@propertyWrapper
public struct HapticControl<T: UIControl> {

    // MARK: - Public Properties

    public var wrappedValue: T {
        willSet {
            self.removeAllHaptics()
        }
        didSet {
            self.addAllHaptics()
        }
    }

    // MARK: - Private Properties

    private var hapticTargets: [T.Event: HapticTarget] = [:]

    // MARK: - Initializers

    public init(
        wrappedValue: T,
        haptics: [T.Event: Haptic]
    ) {
        self.wrappedValue = wrappedValue

        haptics.forEach { self.addHaptic($0.value, for: $0.key) }
    }

    // MARK: - Public Methods

    /// Изменение вибрации для определенного event-а.
    @discardableResult
    public mutating func changeHaptic(_ haptic: Haptic, for event: T.Event) -> Bool {
        guard let target = self.hapticTargets[event] else { return false }

        target.setHaptic(haptic)
        return true
    }

    /// Удаление  вибрации для определенного event-а.
    public mutating func removeHaptic(for event: T.Event) {
        guard let hapticTarget = hapticTargets[event] else { return }

        self.wrappedValue.removeTarget(
            hapticTarget,
            action: #selector(hapticTarget.trigger),
            for: event
        )
    }

    /// Добавление  вибрации для определенного event-а.
    public mutating func addHaptic(_ haptic: Haptic, for event: T.Event) {
        self.removeHaptic(for: event)

        let hapticTarget = HapticTarget(haptic: haptic)
        self.hapticTargets[event] = hapticTarget

        self.wrappedValue.addTarget(
            hapticTarget,
            action: #selector(hapticTarget.trigger),
            for: event
        )
    }

    // MARK: - Private Methods

    private mutating func addAllHaptics() {
        let oldTargets = self.hapticTargets
        self.hapticTargets.removeAll()

        oldTargets.forEach { event, hapticTarget in
            self.addHaptic(
                hapticTarget.getHaptic(),
                for: event
            )
        }
    }

    private func removeAllHaptics() {
        self.hapticTargets.forEach { event, hapticTarget in
            self.wrappedValue.removeTarget(
                hapticTarget,
                action: #selector(hapticTarget.trigger),
                for: event
            )
        }
    }
}
