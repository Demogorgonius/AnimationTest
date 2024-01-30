//
//  ObserveableUIViewPropertyAnimator.swift
//  AnimationTest
//
//  Created by Sergey on 30.01.2024.
//

import UIKit

class ObservableUIViewPropertyAnimator : UIViewPropertyAnimator {
    
    private var displayLink: CADisplayLink?
    private var lastFractionComplete: CGFloat?
    
    /// Called everytime `self.fractionComplete` has a new value.
    var onFractionCompleteUpdated: ((CGFloat) -> ())? = nil {
        didSet {
            if onFractionCompleteUpdated != nil {
                if displayLink == nil {
                    displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
                    displayLink?.add(to: .main, forMode: .common)
                    
                    // Clean up when the animation completes
                    addCompletion { [weak self] _ in
                        self?.displayLink?.invalidate()
                    }
                }
            } else {
                // No longer need display link - clean up
                displayLink?.invalidate()
            }
            
        }
    }
    
    @objc private func handleDisplayLink(_ displayLink: CADisplayLink) {
        // Don't call if the animation is paused or not moving
        if lastFractionComplete != fractionComplete {
            onFractionCompleteUpdated?(fractionComplete)
            lastFractionComplete = fractionComplete
        }
        
        // If the animation stops outside of a normal completion - clean up
        if state == .stopped {
            displayLink.invalidate()
        }
    }
}
