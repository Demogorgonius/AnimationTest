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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setConstraints()
        
    }
    
    func setViews() {
        
        view.addSubview(goToSecondButton)
        
    }
    
    func setConstraints() {
        
        
        goToSecondButton.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        goToSecondButton.addTarget(self, action: #selector(goToSecondButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func goToSecondButtonTapped(_ sender: UIButton) {
        
        presenter.tapGoToSecondView()
        
    }
    
}
