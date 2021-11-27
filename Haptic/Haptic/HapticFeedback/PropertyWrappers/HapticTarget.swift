//
//  HapticTarget.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import Foundation

class HapticTarget {

    // MARK: - Private Properties

    private var haptic: Haptic

    // MARK: - Initializers

    init(haptic: Haptic) {
        self.haptic = haptic
    }

    // MARK: - Internal Methods

    func getHaptic() -> Haptic {
        self.haptic
    }

    func setHaptic(_ haptic: Haptic) {
        self.haptic = haptic
    }

    @objc func trigger() {
        haptic.prepare()
        haptic.generate()
    }
}
