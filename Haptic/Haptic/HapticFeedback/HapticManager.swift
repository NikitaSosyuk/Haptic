//
//  HapticManager.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 29.11.2021.
//

import Foundation

public class HapticManager {

    private enum State {
        case idle
        case performing
        case ended
    }

    // MARK: - Public Properties
    public static let shared = HapticManager()

    // MARK: - Private Properties

    private var state = State.idle
    private var hapticTasks: [Haptic] = []

    // MARK: - Initializers

    private init() { }

    // MARK: - Public Methods

    public func add(haptic: Haptic) {
        hapticTasks.append(haptic)
        guard state == .ended || state == .idle else { return }

        state = .performing
        performNext()
    }

    // MARK: - Private Methods

    private func performNext() {
        guard let haptic = hapticTasks.first
        else {
            state = .ended
            return
        }

        haptic.prepare()
        haptic.generate()
        hapticTasks.removeFirst()
        if hapticTasks.isEmpty {
            state = .ended
        } else {
            performNext()
        }
    }
}
