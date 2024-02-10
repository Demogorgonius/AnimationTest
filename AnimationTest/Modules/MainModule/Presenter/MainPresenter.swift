//
//  MainPresenter.swift
//  AnimationTest
//
//  Created by Sergey on 30.12.2023.
//

import Foundation
import UIKit

protocol MainPresenterProtocol: AnyObject {
    func tapGoToSecondView()
    func tapResumeAnimation()
    func checkForResume() -> Bool
    init(router: MainRouterProtocol, stateManager: StateManagerProtocol)
}

class MainPresenter: MainPresenterProtocol {
    
    var router: MainRouterProtocol!
    var stateManager: StateManagerProtocol!
    
    required init(router: MainRouterProtocol, stateManager: StateManagerProtocol) {
        self.router = router
        self.stateManager = stateManager
    }
    
    func tapGoToSecondView() {
        router.goToSecondView(resumeAnimation: false)
    }
    
    func tapResumeAnimation() {
        router.goToSecondView(resumeAnimation: true)
    }
    
    func checkForResume() -> Bool {
        return stateManager.checkState()
    }
    
}
