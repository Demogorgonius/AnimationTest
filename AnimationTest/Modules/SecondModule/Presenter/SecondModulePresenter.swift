//
//  SecondModulePresenter.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit

protocol SecondModulePresenterProtocol: AnyObject {
    
    init(router: SecondModuleRouterProtocol)
    func goToStartScreen()
    
}

class SecondModulePresenter: SecondModulePresenterProtocol {
    
    var router: SecondModuleRouterProtocol!
    
    required init(router: SecondModuleRouterProtocol) {
        self.router = router
    }
    
    func goToStartScreen() {
        router.goToStartScreen()
    }
    
}
