//
//  SecondModuleBuilder.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit

protocol SecondModuleBuilderProtocol: AnyObject {
    
    func buildSecondModule(resumeAnimation: Bool) -> UIViewController
    init(navigationVC: UINavigationController)
    
}

class SecondModuleBuilder: SecondModuleBuilderProtocol {
    
    var navigationVC: UINavigationController!
    
    required init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func buildSecondModule(resumeAnimation: Bool) -> UIViewController {
        guard let navigationVC = navigationVC else { fatalError("") }
        let vc = SecondModuleViewController()
        let router = SecondModuleRouter(navigationVC: navigationVC)
        let stateManager = StateManager()
        let presenter = SecondModulePresenter(view: vc, router: router, stateManager: stateManager, resumeAnimation: resumeAnimation)
        vc.presenter = presenter
        return vc
    }
    
}
