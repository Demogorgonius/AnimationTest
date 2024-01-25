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
    init(router: MainRouterProtocol)
}

class MainPresenter: MainPresenterProtocol {
    
    var router: MainRouterProtocol!
    
    required init(router: MainRouterProtocol) {
        self.router = router
    }
    
    func tapGoToSecondView() {
        router.goToSecondView()
    }
    
}
