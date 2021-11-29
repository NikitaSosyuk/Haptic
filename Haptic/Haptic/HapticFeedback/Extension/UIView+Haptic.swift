//
//  UIView+Haptic.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 29.11.2021.
//

import Foundation
import UIKit

extension UIView {

    func playHapticFeedback(_ haptic: Haptic) {
        HapticManager.shared.add(haptic: haptic)
    }
}
