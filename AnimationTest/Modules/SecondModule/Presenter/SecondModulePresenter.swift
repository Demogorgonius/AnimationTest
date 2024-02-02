//
//  SecondModulePresenter.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit

enum SuccessType {
    case saveOk
    case deleteOk
    case defaultLoad
    case settingView
}

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

protocol SecondModuleViewProtocol: AnyObject {
    
    func success(successType: SuccessType)
    func failure(error: Error)
    
}

class SecondModulePresenter: SecondModulePresenterProtocol {
    
    weak var view: SecondModuleViewProtocol!
    var router: SecondModuleRouterProtocol!
    var stateManager: StateManagerProtocol!
    var viewModel: ViewModel?
    
    required init(router: SecondModuleRouterProtocol, stateManager: StateManagerProtocol) {
        self.router = router
        self.stateManager = stateManager
        setView()
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
            switch result {
            case .success(let viewModel):
                self.viewModel = viewModel
                self.view.success(successType: .saveOk)
            case .failure(let error):
                self.view.failure(error: error)
            }
        }
        
    }
    
    func deleteState() {
        if stateManager.checkState() {
            stateManager.deleteState { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    if result {
                        self.view.success(successType: .deleteOk)
                    }
                case .failure(let error):
                    self.view.failure(error: error)
                }
            }
        }
    }
    
    func loadView() {
        stateManager.resumeState { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let viewModel):
                self.viewModel = viewModel
            case .failure(let error):
                self.view.failure(error: error)
            }
        }
    }
    
    func setView() {
        
        if stateManager.checkState() {
            loadView()
            if viewModel != nil {
                view.success(successType: .settingView)
            }
        } else {
            view.success(successType: .defaultLoad)
        }
        
    }
    
}
