//
//  StateManager.swift
//  AnimationTest
//
//  Created by Sergey on 02.02.2024.
//

import Foundation
import UIKit

protocol StateManagerProtocol: AnyObject {
    
    func saveState(vPosition: CGRect,
                   tPosition: CGRect,
                   bColor: Int,
                   fColor: Int,
                   restTime: Int,
                   duration: TimeInterval,
                   remainingDuration: TimeInterval,
                   completion: @escaping(Result<ViewModel, Error>) -> Void)
    
    func resumeState( completion: @escaping(Result<ViewModel, Error>) -> Void )
    
    func checkState() -> Bool
    
    func deleteState(completion: @escaping(Result<Bool, Error>) -> Void)
    
}

class StateManager: StateManagerProtocol {
    
    let defaults = UserDefaults.standard
    
    func saveState(vPosition: CGRect,
                   tPosition: CGRect,
                   bColor: Int,
                   fColor: Int,
                   restTime: Int,
                   duration: TimeInterval,
                   remainingDuration: TimeInterval,
                   completion: @escaping(Result<ViewModel, Error>) -> Void) {
        
        let encoder = JSONEncoder()
        
        let currentView = ViewModel(viewPosition: vPosition,
                                    textPosition: tPosition,
                                    backgroundColor: bColor,
                                    textColor: fColor,
                                    duration: duration,
                                    remainingDuration: remainingDuration,
                                    theRestOfTheCountdown: restTime)
        
        if let encoded = try? encoder.encode(currentView) {
            
            defaults.set(encoded, forKey: "resumeSettings")
        }
        
        if let settings = defaults.object(forKey: "resumeSettings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(ViewModel.self, from: settings) {
            
                completion(.success(loadedSettings))
                
            } else {
                completion(.failure(Errors.getSettingsError))
            }
            
        }
        
        
    }
    
    func resumeState(completion: @escaping(Result<ViewModel, Error>) -> Void ) {
        
        if let settings = defaults.object(forKey: "resumeSettings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(ViewModel.self, from: settings) {
            
                completion(.success(loadedSettings))
                
            } else {
                completion(.failure(Errors.getSettingsError))
            }
            
        }
        
        
    }
    
    func checkState() -> Bool {
        
        if defaults.object(forKey: "resumeSettings") is Data {
            return true
        } else {
            return false
        }
        
    }
    
    func deleteState(completion: @escaping (Result<Bool, Error>) -> Void) {
        if defaults.object(forKey: "resumeSettings") is Data {
            defaults.set(nil, forKey: "resumeSettings")
            completion(.success(true))
        } else {
            completion(.failure(Errors.savedStateEmpty))
        }
    }
    
}
