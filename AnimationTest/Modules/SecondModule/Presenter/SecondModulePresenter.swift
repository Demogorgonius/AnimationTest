//
//  SecondModulePresenter.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit

protocol SecondModulePresenterProtocol: AnyObject {
    
    init(router: SecondModuleRouterProtocol, stateManager: StateManagerProtocol)
    func goToStartScreen()
    func saveState(vPosition: CGRect,
                   tPosition: CGRect,
                   bColor: Int,
                   fColor: Int,
                   restTime: Int,
                   duration: TimeInterval)
}

class SecondModulePresenter: SecondModulePresenterProtocol {
    
    var router: SecondModuleRouterProtocol!
    var stateManager: StateManagerProtocol!
    
    required init(router: SecondModuleRouterProtocol, stateManager: StateManagerProtocol) {
        self.router = router
        self.stateManager = stateManager
    }
    
    func goToStartScreen() {
        router.goToStartScreen()
    }
    
    func saveState(vPosition: CGRect,
                   tPosition: CGRect,
                   bColor: Int,
                   fColor: Int,
                   restTime: Int,
                   duration: TimeInterval) {
        
        stateManager.saveState(vPosition: vPosition,
                               tPosition: tPosition,
                               bColor: bColor,
                               fColor: fColor,
                               restTime: restTime,
                               duration: duration) { [weak self] result in
            guard let self = self else { return }
        }
        
    }
    
}
