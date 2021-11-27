//
//  HapticView.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import UIKit

@propertyWrapper
public struct HapticView<T: UIView>{

    public enum Event: Hashable {
        case tap
        case longPress
    }

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

    private var hapticTargets: [Event: HapticTarget] = [:]
    private var hapticRecognizers: [Event: UIGestureRecognizer] = [:]

    // MARK: - Initializers

    public init(
        wrappedValue: T,
        haptics: [Event: Haptic]
    ) {
        self.wrappedValue = wrappedValue

        haptics.forEach { self.addHaptic($0.value, for: $0.key) }
    }

    // MARK: - Public Methods

    /// Изменение вибрации для определенного event-а.
    @discardableResult
    public mutating func changeHaptic(_ haptic: Haptic, for event: Event) -> Bool {
        guard let target = self.hapticTargets[event] else { return false }

        target.setHaptic(haptic)
        return true
    }

    /// Удаление  вибрации для определенного event-а.
    public mutating func removeHaptic(for event: Event) {
        guard let hapticRecognizer = self.hapticRecognizers[event] else { return }

        wrappedValue.removeGestureRecognizer(hapticRecognizer)
    }

    /// Добавление  вибрации для определенного event-а.
    public mutating func addHaptic(_ haptic: Haptic, for event: Event) {
        self.removeHaptic(for: event)

        let hapticTarget = HapticTarget(haptic: haptic)
        let gestureRecognizer: UIGestureRecognizer
        switch event {
        case .longPress:
            gestureRecognizer = UILongPressGestureRecognizer(
                target: hapticTarget,
                action: #selector(hapticTarget.trigger)
            )

        case .tap:
            gestureRecognizer = UITapGestureRecognizer(
                target: hapticTarget,
                action: #selector(hapticTarget.trigger)
            )
        }

        self.hapticTargets[event] = hapticTarget
        self.wrappedValue.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Private Methods

    private mutating func addAllHaptics() {
        self.hapticRecognizers.forEach { self.wrappedValue.addGestureRecognizer($0.value) }
    }

    private func removeAllHaptics() {
        self.hapticRecognizers.forEach { self.wrappedValue.removeGestureRecognizer($0.value) }
    }
}
