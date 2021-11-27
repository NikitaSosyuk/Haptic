//
//  UIDevice+Model.swift
//  Haptic
//
//  Created by Nikita Sosyuk on 27.11.2021.
//

import UIKit

extension UIDevice {

    public static var currentModelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                  value != 0
            else { return identifier }

            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }
}
