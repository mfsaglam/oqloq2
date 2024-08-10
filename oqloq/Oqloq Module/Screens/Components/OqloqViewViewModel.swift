//
//  OqloqViewViewModel.swift
//  oqloq
//
//  Created by Saglam, Fatih on 16.07.2024.
//

import SwiftUI

class OqloqViewViewModel: ObservableObject {
    @Published var angle: Angle = .init(degrees: .zero)
    
    let engine: ClockEngineInterface
    
    init(engine: ClockEngineInterface) {
        self.engine = engine
        updateAngle()
        engine.updateAnglePeriodically() { [weak self] in
            guard let self else { return }
            self.updateAngle()
        }
    }
    
    private func updateAngle() {
        angle = engine.currentAngle()
    }
}
