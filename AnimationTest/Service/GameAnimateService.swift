//
//  GameAnimateService.swift
//  AnimationTest
//
//  Created by Sergey on 19.02.2024.
//

import Foundation
import UIKit

enum DurationType {
    
    case pause
    case changeSpeed
    case normal
    case exit
    
}

protocol GameServiceProtocol: AnyObject {
    var countOfRepeats: Int { get set }
    var viewAnimator: UIViewPropertyAnimator? {get set}
    var viewAlphaAnimator: ObservableUIViewPropertyAnimator? {get set}
    var animationTimerStart: DispatchTime? {get set}
    var animationTimerEnd: DispatchTime? {get set}
    var pauseAnimationTimerEnd: DispatchTime? {get set}
    var pauseAnimationTimerStart: DispatchTime? {get set}
    var speedDimensionAnimationStart: DispatchTime? {get set}
    var viewMoveTime: TimeInterval {get set}
    var newViewMoveTime: TimeInterval {get set}
    var isAlphaAnimationStarting: Bool {get set}
    var speedButtonTap: Bool {get set}
    func startAnimation(colorView: UIView, colorLabel: UILabel, repeated: Int, moveViewTime: TimeInterval, durationType: DurationType, startAnimationTime: DispatchTime?, viewPosition: [CGRect]?)
    func moveViewToTop(_ view: UIView, _ label: UILabel)
    func setViewPosition( _ view: UIView, _ label: UILabel)
    func getViewCoordinate(view: UIView) -> CGRect
    func getDuration(stopAnimationTime: DispatchTime?, startAnimationTime: DispatchTime?, durationType: DurationType) -> TimeInterval
    func resumeAnimation(colorView: UIView, colorLabel: UILabel, stopAnimationTime: DispatchTime?, startAnimationTime: DispatchTime?, durationType: DurationType)
    
}

class GameService: GameServiceProtocol {
    
    var viewAnimator: UIViewPropertyAnimator?
    var viewAlphaAnimator: ObservableUIViewPropertyAnimator?
    var viewMoveTime = TimeInterval(3.0)
    var newViewMoveTime = TimeInterval(0.0)
    var countOfRepeats: Int = 1000
    var animationTimerStart, animationTimerEnd, pauseAnimationTimerEnd, pauseAnimationTimerStart, speedDimensionAnimationStart: DispatchTime?
    var speedButtonTap: Bool = false
    var lastPauseDuration: TimeInterval = 0.0
    var pastTimeChangeSpeedAnimation: TimeInterval = 0.0
    var currentDuration: TimeInterval = 0.0
    var isAlphaAnimationStarting: Bool = false
    
    //MARK: - Services variables
    var isPause: Bool = false
    var exitByTimer: Bool = false
    var isRestoreAnimation: Bool = false
    
    func startAnimation(colorView: UIView, colorLabel: UILabel, repeated: Int, moveViewTime: TimeInterval, durationType: DurationType, startAnimationTime: DispatchTime?, viewPosition: [CGRect]?) {
        
        var duration: Double = 0.0
        
        if repeated < 0 { return }
        if isRestoreAnimation == true {
            isRestoreAnimation = false
        } else {
            colorView.alpha = 1
            colorLabel.alpha = 1
        }
        if viewPosition == nil {
            setViewPosition(colorView, colorLabel)
        }

        var fadeStart = moveViewTime - moveViewTime/4
        switch durationType {
        case .pause:
            pauseAnimationTimerStart = DispatchTime.now()
            speedDimensionAnimationStart = DispatchTime.now()
            duration  = moveViewTime
            currentDuration = duration
            
        case .changeSpeed:
            speedDimensionAnimationStart = DispatchTime.now()
            pauseAnimationTimerStart = DispatchTime.now()
            duration = moveViewTime
            currentDuration = duration
            
        case .normal:
            animationTimerStart = DispatchTime.now()
            lastPauseDuration = 0.0
            pastTimeChangeSpeedAnimation = 0.0
            pauseAnimationTimerStart = nil
            speedDimensionAnimationStart = nil
            duration = viewMoveTime
            currentDuration = duration
        case .exit:
            print("exit")
        }

        viewAnimator = UIViewPropertyAnimator(duration: TimeInterval(duration), curve: .linear) { [weak self] in
            
            guard let self = self else { return }
            moveViewToTop(colorView, colorLabel)
            
        }
        
        viewAlphaAnimator = ObservableUIViewPropertyAnimator(duration: TimeInterval(duration/4), curve: .easeIn) {[weak self] in
            
            guard let self = self else { return }
           
            fadeOutView(colorView, colorLabel)
           

        }
        
        viewAnimator?.addAnimations { [weak self] in
            
            guard let self = self else { return }
            if durationType == .changeSpeed {
                viewMoveTime = newViewMoveTime
            }
            fadeStart = moveViewTime - moveViewTime/4
            if fadeStart <= 0 {
                fadeStart = 0.1
                print("WARNING!!!!")
            }
            viewAlphaAnimator?.startAnimation(afterDelay: fadeStart)
            
        }
        
        
        
        viewAlphaAnimator?.addCompletion { [weak self] _ in
           
            guard let self = self else { return }
            colorView.alpha = 0
            colorLabel.alpha = 0
            colorView.backgroundColor = ColorViewFactory().getRandomColor()
            colorLabel.text = ColorLabelFactory().getRandomColor()
            if durationType == .changeSpeed {
                viewMoveTime = newViewMoveTime
                newViewMoveTime = 0.0
            }
            speedDimensionAnimationStart = nil
            duration = viewMoveTime
            isAlphaAnimationStarting = false
            startAnimation(colorView: colorView, colorLabel: colorLabel, repeated: repeated - 1, moveViewTime: duration, durationType: .normal, startAnimationTime: nil, viewPosition: nil)
            
        }
        
        viewAlphaAnimator?.onFractionCompleteUpdated = { fractionComplete in
            if fractionComplete != 0.0 {
                self.isAlphaAnimationStarting = true
            }
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
    
    func getDuration(stopAnimationTime: DispatchTime?, startAnimationTime: DispatchTime?, durationType: DurationType) -> TimeInterval {
        
        guard let animationTimerStart = startAnimationTime else { return 0.0 }
        animationTimerEnd = stopAnimationTime ?? DispatchTime.now()
        guard let animationTimerEnd = animationTimerEnd else { return 0.0 }
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
            if let speedDimensionAnimationStart = startAnimationTime {
                
                let start = speedDimensionAnimationStart.uptimeNanoseconds
                let time = end - start
                let dTime = Double(time)
                let secTime = dTime/1000000000.00
                let speedDuration = viewMoveTime - (pastTimeChangeSpeedAnimation + secTime )
                pastTimeChangeSpeedAnimation += secTime
                duration = speedDuration*(newViewMoveTime*100/viewMoveTime)/100
                
        
            }
            
            if pastTimeChangeSpeedAnimation == 0.0 {
                pastTimeChangeSpeedAnimation += secTime
            }
    
        case .normal:
            print("normal duration.")
        case .exit:
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
        }
        
        return duration
        
    }
    
    func resumeAnimation(colorView: UIView, colorLabel: UILabel, stopAnimationTime: DispatchTime?, startAnimationTime: DispatchTime?, durationType: DurationType) {
        
        let duration = getDuration(stopAnimationTime: stopAnimationTime, startAnimationTime: startAnimationTime, durationType: durationType)
        
        let positionOfView = [getViewCoordinate(view: colorView), getViewCoordinate(view: colorLabel)]
        startAnimation(colorView: colorView, colorLabel: colorLabel, repeated: countOfRepeats,
                       moveViewTime: duration,
                       durationType: durationType,
                       startAnimationTime: startAnimationTime,
                       viewPosition: positionOfView)
        
    }
    
}
