//
//  MainRouter.swift
//  AnimationTest
//
//  Created by Sergey on 30.12.2023.
//

import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    
    func goToSecondView()
    init(navigationVC: UINavigationController)
    
}

class MainRouter: MainRouterProtocol {
    
    weak var navigationVC: UINavigationController?
    
    required init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func goToSecondView() {
        guard let navVC = navigationVC else { return }
        let vc = SecondModuleBuilder(navigationVC: navVC).buildSecondModule()
        navVC.pushViewController(vc, animated: true)
    }
    
}
