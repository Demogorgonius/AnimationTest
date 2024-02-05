//
//  MainRouter.swift
//  AnimationTest
//
//  Created by Sergey on 30.12.2023.
//

import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    
    func goToSecondView(resumeAnimation: Bool)
    init(navigationVC: UINavigationController)
    
}

class MainRouter: MainRouterProtocol {
    
    weak var navigationVC: UINavigationController?
    
    required init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func goToSecondView(resumeAnimation: Bool) {
        guard let navVC = navigationVC else { return }
        let vc = SecondModuleBuilder(navigationVC: navVC).buildSecondModule(resumeAnimation: resumeAnimation)
        navVC.pushViewController(vc, animated: true)
    }
    
}
