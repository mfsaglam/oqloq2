//
//  HomeViewModel.swift
//  oqloq
//
//  Created by Fatih Sağlam on 31.08.2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var presentableRoutines: [PresentableRoutine] = []
    
    private let interactor: RoutineService
    var data: [RoutineDTO] = []
    
    init(interactor: RoutineService) {
        self.interactor = interactor
    }
    
    func getData() {
        do {
            let routines = try interactor.loadRoutines()
            self.data = routines
        } catch {
            print(error.localizedDescription)
        }
        
        self.presentableRoutines = data.map { $0.presentable }
    }
}
