//
//  SecondModuleViewController.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit
import SnapKit

enum DurationType {
    
    case pause
    case changeSpeed
    case normal
    
}

class SecondModuleViewController: UIViewController {
    
    //MARK: - Injection
    var presenter: SecondModulePresenterProtocol!
    
    var viewAnimator, viewAlphaAnimation: UIViewPropertyAnimator?
    
    //MARK: - Timer settings
    var timer: Timer?
    var totalTime = 30
    var secondPassed = 0
    var elapsedTime: Int?
    
    //MARK: - Animation settings
    var viewMoveTime = TimeInterval(3.0)
    var newViewMoveTime = TimeInterval(0.0)
    var countOfRepeats: Int = 1000
    var animationTimerStart, animationTimerEnd, pauseAnimationTimerEnd, pauseAnimationTimerStart, speedDimensionAnimationStart: DispatchTime?
    var speedButtonTap: Bool = false
    var lastPauseDuration: TimeInterval = 0.0
    var pastTimeChangeSpeedAnimation: TimeInterval = 0.0
    
    //MARK: - Services variables
    var isPause: Bool = false
       
    
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
    }
    
    //MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConstraints()
        timerStart()
        
    }
    
    //MARK: - UI methods
    
    func setViews() {
        view.backgroundColor = .lightGray
        view.addSubview(colorView)
        view.addSubview(timerLabel)
        view.addSubview(pauseButton)
        view.addSubview(speedButton)
        view.addSubview(speedReductionButton)
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
        
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        speedButton.addTarget(self, action: #selector(speedButtonTapped), for: .touchUpInside)
        speedReductionButton.addTarget(self, action: #selector(speedReductionButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Timers methods
    
    func timerStart() {
        if timer != nil {
            timer!.invalidate()
        }
        secondPassed = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:  self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        if isPause != true {
            startAnimation(repeated: countOfRepeats, moveViewTime: viewMoveTime, durationType: .normal, startAnimationTime: nil, viewPosition: nil)
        }
        
    }
    
    @objc func updateTimer() {
        
        if secondPassed < totalTime {
            
            secondPassed += 1
            timerLabel.text = String(totalTime-secondPassed)
            
        } else {
            
            timer!.invalidate()
            timer = nil
            viewAnimator?.stopAnimation(true)
            viewAlphaAnimation?.stopAnimation(true)
            presenter.goToStartScreen()
            
        }
        
    }
    
    //MARK: - Animation methods
    
    func startAnimation(repeated: Int, moveViewTime: TimeInterval, durationType: DurationType, startAnimationTime: DispatchTime?, viewPosition: [CGRect]?) {
        
        var duration: Double = 0.0
        
        if repeated < 0 { return }
        colorView.alpha = 1
        colorLabel.alpha = 1
        if viewPosition == nil {
            setViewPosition(colorView, colorLabel)
        }
        
        switch durationType {
        case .pause:
            pauseAnimationTimerStart = DispatchTime.now()
            duration  = moveViewTime
        case .changeSpeed:
            speedDimensionAnimationStart = DispatchTime.now()
            duration = moveViewTime*(newViewMoveTime*100/viewMoveTime)/100
        case .normal:
            animationTimerStart = DispatchTime.now()
            lastPauseDuration = 0.0
            pastTimeChangeSpeedAnimation = 0.0
            pauseAnimationTimerStart = nil
            speedDimensionAnimationStart = nil
            duration = viewMoveTime
        }
        
        let fadeStart = moveViewTime - moveViewTime/4

        viewAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .linear) { [weak self] in
            
            guard let self = self else { return }
            self.moveViewToTop(self.colorView, self.colorLabel)
            if durationType == .changeSpeed {
                viewMoveTime = newViewMoveTime
            }
        }
        
        viewAlphaAnimation = UIViewPropertyAnimator(duration: TimeInterval(duration/4), curve: .easeIn) {[weak self] in
            
            guard let self = self else { return }
            self.fadeOutView(self.colorView, self.colorLabel)
            if durationType == .changeSpeed {
                viewMoveTime = newViewMoveTime
            }
        }
        
        viewAnimator?.addAnimations { [weak self] in
            
            guard let self = self else { return }
            viewAlphaAnimation?.startAnimation(afterDelay: fadeStart)
            
        }
        
        viewAlphaAnimation?.addCompletion { [weak self] _ in
        
            guard let self = self else { return }
            self.colorView.alpha = 0
            self.colorLabel.alpha = 0
            self.colorView.backgroundColor = ColorViewFactory().getRandomColor()
            self.colorLabel.text = ColorLabelFactory().getRandomColor()
            if durationType == .changeSpeed {
                viewMoveTime = newViewMoveTime
            }
            duration = viewMoveTime
            self.startAnimation(repeated: repeated - 1, moveViewTime: duration, durationType: .normal, startAnimationTime: nil, viewPosition: nil)
            
        }
        
        viewAnimator?.startAnimation()

    }
    
    func moveViewToTop(_ view: UIView, _ label: UILabel) {
        
        view.frame = CGRect(
            x: view.frame.origin.x,
            y: 0.0,
            width: 200,
            height: 70
        )
        label.frame = CGRect(
            x: label.frame.origin.x,
            y: 0.0,
            width: 200,
            height: 70
        )
        
    }
    
    func fadeOutView(_ view: UIView, _ label: UILabel) {
        
        view.alpha = 0
        label.alpha = 0
        
    }
    
    
    
    func setViewPosition( _ view: UIView, _ label: UILabel) {
        
        view.alpha = 1
        label.alpha = 1
        
        let xPosition = UIScreen.main.bounds.width/2 - Double.random(in: 0...200)
        let yPosition = UIScreen.main.bounds.height - 100.0
        view.frame = CGRect(
            x: xPosition,
            y: yPosition,
            width: 200,
            height: 70
        )
        
        
        
        label.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: 200,
            height: 70
        )
        
    }
    
    func getViewCoordinate(view: UIView) -> CGRect {
        
        return CGRect(origin: view.frame.origin, size: view.frame.size)
        
    }
    
}

//MARK: - Extensions

extension SecondModuleViewController {
    
    func resumeAnimation(stopAnimationTime: DispatchTime?, startAnimationTime: DispatchTime?, durationType: DurationType) {
        
        
        guard let animationTimerStart = animationTimerStart else { return }
        let positionOfView = [getViewCoordinate(view: colorView), getViewCoordinate(view: colorLabel)]
        animationTimerEnd = stopAnimationTime ?? DispatchTime.now()
        guard let animationTimerEnd = animationTimerEnd else { return }
        let end = animationTimerEnd.uptimeNanoseconds
        let start = animationTimerStart.uptimeNanoseconds
        let time = end - start
        let dTime = Double(time)
        let secTime = dTime/1000000000.00
        var duration: TimeInterval = viewMoveTime - secTime
        
        switch durationType {
        case .pause:
            
            if let pauseAnimationTimerStart = pauseAnimationTimerStart {
                
                let start = pauseAnimationTimerStart.uptimeNanoseconds
                let time = end - start
                let dTime = Double(time)
                let secTime = dTime/1000000000.00
                duration = viewMoveTime - (lastPauseDuration + secTime )
                lastPauseDuration += secTime
        
            }
            
            if lastPauseDuration == 0.0 {
                lastPauseDuration += secTime
            }
            
        case .changeSpeed:
            print("changed speed duration.")
            if let speedDimensionAnimationStart = speedDimensionAnimationStart {
                
                let start = speedDimensionAnimationStart.uptimeNanoseconds
                let time = end - start
                let dTime = Double(time)
                let secTime = dTime/1000000000.00
                duration = viewMoveTime - (pastTimeChangeSpeedAnimation + secTime )
                pastTimeChangeSpeedAnimation += secTime
        
            }
            
            if pastTimeChangeSpeedAnimation == 0.0 {
                pastTimeChangeSpeedAnimation += secTime
            }
            
            
        case .normal:
            print("normal duration.")
        }
        
        startAnimation(repeated: countOfRepeats , moveViewTime: duration, durationType: durationType, startAnimationTime: startAnimationTime, viewPosition: positionOfView)
        
    }
    
    @objc func pauseButtonTapped() {
        
        if isPause == false {
            
            totalTime -= secondPassed
            pauseAnimationTimerEnd = DispatchTime.now()
            timer?.invalidate()
            viewAnimator?.stopAnimation(true)
            viewAlphaAnimation?.stopAnimation(true)
            isPause = true
            
        } else {
            
            timerStart()
            isPause = false
            resumeAnimation(stopAnimationTime: pauseAnimationTimerEnd, startAnimationTime: animationTimerStart, durationType: .pause)
            
        }
        
    }
    
    @objc func speedButtonTapped(_ sender: UIButton) {
        guard let viewAnimator = viewAnimator else { return }
        if viewAnimator.isRunning == false { print(" animation is paused, can not change animation speed! "); return }
        if viewMoveTime > 0.5 {
            
            newViewMoveTime = viewMoveTime - TimeInterval(0.5)
            
        } else {
            
            return
            
        }
        
        viewAnimator.stopAnimation(true)
        viewAlphaAnimation?.stopAnimation(true)
        animationTimerEnd = DispatchTime.now()
        resumeAnimation(stopAnimationTime: nil, startAnimationTime: speedDimensionAnimationStart, durationType: .changeSpeed)
            
    }
    
    @objc func speedReductionButtonTapped(_ sender: UIButton) {
        guard let viewAnimator = viewAnimator else { return }
        if viewAnimator.isRunning == false { print(" animation is paused, can not change animation speed! "); return }
        if viewMoveTime > 0.5 {
            
            newViewMoveTime = viewMoveTime + TimeInterval(0.5)
            
        } else {
            
            return
            
        }
        
        viewAnimator.stopAnimation(true)
        viewAlphaAnimation?.stopAnimation(true)
        animationTimerEnd = DispatchTime.now()
        resumeAnimation(stopAnimationTime: nil, startAnimationTime: speedDimensionAnimationStart, durationType: .changeSpeed)
            
    }
            
}
