//
//  MainViewController.swift
//  AnimationTest
//
//  Created by Sergey on 30.12.2023.
//

import Foundation
import UIKit
import SnapKit


class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    
    lazy var goToSecondButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Start animate", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var resumeAnimationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Resume animation", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setConstraints()
        if presenter.checkForResume() {
            resumeAnimationButton.isHidden = false
        } else {
            resumeAnimationButton.isHidden = true
        }
        
        
    }
    
    func setViews() {
        
        view.addSubview(goToSecondButton)
        view.addSubview(resumeAnimationButton)
        
    }
    
    func setConstraints() {
        
        
        goToSecondButton.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        resumeAnimationButton.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(goToSecondButton.snp.bottom).offset(15)
        }
        
        
        
        goToSecondButton.addTarget(self, action: #selector(goToSecondButtonTapped), for: .touchUpInside)
        resumeAnimationButton.addTarget(self, action: #selector(resumeAnimationButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func goToSecondButtonTapped(_ sender: UIButton) {
        
        presenter.tapGoToSecondView()
        
    }
    
    @objc func resumeAnimationButtonTapped(_ sender: UIButton) {
        presenter.tapResumeAnimation()
    }
    
}
