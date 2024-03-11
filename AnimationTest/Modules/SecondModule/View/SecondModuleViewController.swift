//
//  SecondModuleViewController.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit
import SnapKit



class SecondModuleViewController: UIViewController {
    
    //MARK: - Injection
    
    var viewModel: ViewModel?
    var presenter: SecondModulePresenterProtocol!
    var gameService: GameServiceProtocol!
    
    //MARK: - Timer settings
    
    var timer: Timer?
    var totalTime = 30
    var secondPassed = 0
    var elapsedTime: Int?
    
    //MARK: - Services variables
    
    var isPause: Bool = false
    var exitByTimer: Bool = false
       
    //MARK: - User interface
    
    lazy var colorView: UIView = {
        
        let view = ColorViewFactory.createShadowView().shadowColorView
        view.backgroundColor = ColorViewFactory().getRandomColor()
        return view
        
    }()
    
    lazy var colorLabel: UILabel = {
        
        let label = ColorLabelFactory.createShadowLabel().shadowColorLabel
        label.text = ColorLabelFactory().getRandomColor()
        return label
        
    }()
    
    
    lazy var pauseLabel: UILabel = {
        
        let label = ColorLabelFactory.createShadowLabel().shadowColorLabel
        label.textColor = UIColor(cgColor: CGColor(red: 65, green: 65, blue: 90, alpha: 100))
        label.text = "PAUSE"
        return label
        
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = String(totalTime)
        return label
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var speedButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "goforward.plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
        
    }()
    
    lazy var speedReductionButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward.minus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
        
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        if presenter.resumeAnimation == true {
            presenter.setView()
        }
    }
    
    //MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConstraints()
        timerLabel.text = String(totalTime)
        if isPause == false {
            pauseLabel.isHidden = true
        } else {
            pauseLabel.isHidden = false
        }
        if presenter.resumeAnimation == false {
            timerStart()
        }
        
    }
    
    //MARK: - ViewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent && exitByTimer == false {
            
            if isPause == false {
                
                totalTime -= secondPassed
                gameService.pauseAnimationTimerEnd = DispatchTime.now()
                timer?.invalidate()
                gameService.viewAnimator?.stopAnimation(true)
                gameService.viewAlphaAnimator?.stopAnimation(true)
                
            }
            
            let duration = gameService.getDuration(stopAnimationTime: gameService.pauseAnimationTimerEnd, 
                                                   startAnimationTime: gameService.animationTimerStart,
                                                   durationType: .exit)
            presenter.saveState(vPosition: gameService.getViewCoordinate(view: colorView),
                                tPosition: gameService.getViewCoordinate(view: colorLabel),
                                bColor: ColorViewFactory().getCurentIndex(colorView.backgroundColor ?? .red),
                                fColor: ColorLabelFactory().getCurentIndex(colorLabel.text ?? "красный"),
                                restTime: totalTime,
                                duration: gameService.viewMoveTime,
                                remainingDuration: duration,
                                alpha: colorView.alpha)
        }
        if exitByTimer == true {
            presenter.deleteState()
        }
    }
    
    //MARK: - UI methods
    
    func setViews() {
        view.backgroundColor = .lightGray
        view.addSubview(colorView)
        view.addSubview(timerLabel)
        view.addSubview(pauseButton)
        view.addSubview(speedButton)
        view.addSubview(speedReductionButton)
        view.addSubview(pauseLabel)
        colorView.addSubview(colorLabel)
    }
    
    func setConstraints() {
        
        timerLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        speedButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        speedReductionButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        pauseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        speedButton.addTarget(self, action: #selector(speedButtonTapped), for: .touchUpInside)
        speedReductionButton.addTarget(self, action: #selector(speedReductionButtonTapped), for: .touchUpInside)
    }
    
    func makeColorButtons() {
        var buttons: [ColorButton] = []
        var tag: Int = 0
        for buttonColor in ColorButtonFactory().colors {
            let button = ColorButtonFactory.makeShadowButton(backgroundColor: buttonColor,
                                                             title: "",
                                                             target: self,
                                                             tag: tag,
                                                             action: nil)
            buttons.append(button)
            tag += 1
        }
        
    }
    
    //MARK: - Timers methods
    
    func timerStart() {
        if timer != nil {
            timer!.invalidate()
        }
        secondPassed = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:  self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        if isPause != true && presenter.resumeAnimation != true {
            gameService.startAnimation(colorView: colorView, 
                                       colorLabel: colorLabel,
                                       repeated: gameService.countOfRepeats,
                                       moveViewTime: gameService.viewMoveTime,
                                       durationType: .normal,
                                       startAnimationTime: nil,
                                       viewPosition: nil)
        }
        
    }
    
    @objc func updateTimer() {
        
        if secondPassed < totalTime {
            
            secondPassed += 1
            timerLabel.text = String(totalTime-secondPassed)
            
        } else {
            
            timer!.invalidate()
            timer = nil
            gameService.viewAnimator?.stopAnimation(true)
            gameService.viewAlphaAnimator?.stopAnimation(true)
            exitByTimer = true
            presenter.goToStartScreen()
            
        }
        
    }
    
}

//MARK: - Extensions

extension SecondModuleViewController {

    
//MARK: - @objc methods
    
    @objc func pauseButtonTapped() {
        
        if isPause == false {
            
            totalTime -= secondPassed
            gameService.pauseAnimationTimerEnd = DispatchTime.now()
            timer?.invalidate()
            gameService.viewAnimator?.stopAnimation(true)
            gameService.viewAlphaAnimator?.stopAnimation(true)
            pauseLabel.isHidden = false
            isPause = true
            
        } else {
            
            pauseLabel.isHidden = true
            if gameService.isRestoreAnimation == true {
                
                viewModel = presenter.viewModel
                guard let viewModel = viewModel else { return }
                timerStart()
                isPause = false
                gameService.startAnimation(colorView: colorView, 
                                           colorLabel: colorLabel,
                                           repeated: 1000,
                                           moveViewTime: viewModel.remainingDuration,
                                           durationType: .pause,
                                           startAnimationTime: nil,
                                           viewPosition: [viewModel.viewPosition, viewModel.textPosition])

            } else {
                
                timerStart()
                isPause = false
                gameService.resumeAnimation(colorView: colorView, 
                                            colorLabel: colorLabel,
                                            stopAnimationTime: gameService.pauseAnimationTimerEnd,
                                            startAnimationTime: gameService.animationTimerStart,
                                            durationType: .pause)

                
            }
            
            
        }
        
    }
    
    @objc func speedButtonTapped(_ sender: UIButton) {
        guard let viewAnimator = gameService.viewAnimator else { return }
        
        if viewAnimator.isRunning == false {
            return
        }
        if gameService.isAlphaAnimationStarting == true {
            print("Alpha animation starting! Can't change speed animation!!!")
            return
        }
        if gameService.viewMoveTime > 0.5 {
            gameService.newViewMoveTime = gameService.viewMoveTime - TimeInterval(0.5)
        } else {
            return
        }
        
        var start = gameService.animationTimerStart
        if gameService.speedDimensionAnimationStart != nil {
            start = gameService.speedDimensionAnimationStart
        }
        
        viewAnimator.stopAnimation(true)
        gameService.viewAlphaAnimator?.stopAnimation(true)
        gameService.animationTimerEnd = DispatchTime.now()
        gameService.resumeAnimation(colorView: colorView, 
                                    colorLabel: colorLabel,
                                    stopAnimationTime: nil,
                                    startAnimationTime: start,
                                    durationType: .changeSpeed)
        
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        
        
        
    }
        
    @objc func speedReductionButtonTapped(_ sender: UIButton) {
        guard let viewAnimator = gameService.viewAnimator else { return }
        if viewAnimator.isRunning == false {
            return
        }
        if gameService.isAlphaAnimationStarting == true {
            print("Alpha animation starting! Can't change speed animation!!!")
            return
        }
        var start = gameService.animationTimerStart
        if gameService.speedDimensionAnimationStart != nil {
            start = gameService.speedDimensionAnimationStart
        }
        gameService.newViewMoveTime = gameService.viewMoveTime + TimeInterval(0.5)
        viewAnimator.stopAnimation(true)
        gameService.viewAlphaAnimator?.stopAnimation(true)
        gameService.animationTimerEnd = DispatchTime.now()
        gameService.resumeAnimation(colorView: colorView, 
                                    colorLabel: colorLabel,
                                    stopAnimationTime: nil,
                                    startAnimationTime: start,
                                    durationType: .changeSpeed)
        
    }
    
}

extension SecondModuleViewController: SecondModuleViewProtocol {
    
    func success(successType: SuccessType) {
        switch successType {
        case .saveOk:
            
            presenter.goToStartScreen()
            
        case .deleteOk:
            
           print("State deleted!")
            
        case .defaultLoad:
            
            timerStart()
            
        case .settingView:
            
            viewModel = presenter.viewModel
            guard let viewModel = viewModel else { return }
            colorView.frame = viewModel.viewPosition
            colorLabel.frame = viewModel.textPosition
            colorView.backgroundColor = ColorViewFactory().getColor(viewModel.backgroundColor)
            colorLabel.text = ColorLabelFactory().getColor(viewModel.textColor)
            totalTime = viewModel.theRestOfTheCountdown
            gameService.viewMoveTime = viewModel.duration
            colorView.alpha = viewModel.alpha
            colorLabel.alpha = viewModel.alpha
            gameService.isRestoreAnimation = true
            isPause = true
            pauseLabel.isHidden = false
 
        }
    }
    
    func failure(error: Error) {
        let alert = UIAlertController(title: "Warning!", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.presenter.goToStartScreen()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            self.presenter.goToStartScreen()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
}
        
    

