//
//  ClockEngineInterface.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

protocol ClockEngineInterface {
    func currentAngle() -> Angle
    func updateAnglePeriodically(completion: @escaping () -> Void)
}
