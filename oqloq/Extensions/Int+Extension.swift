//
//  Int+Extension.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

extension Int {
    func angle() -> Angle {
        return .init(degrees: Double(self) / 60 * 15)
    }
}
