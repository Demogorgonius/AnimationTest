//
//  ErrorsList.swift
//  AnimationTest
//
//  Created by Sergey on 01.02.2024.
//

import Foundation

enum Errors: Error {
    case savedStateEmpty
    case saveSettingsError
    case getSettingsError
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .savedStateEmpty:
            return NSLocalizedString("У Вас нет сохраненной анимации!", comment: "Невозможно выполнить действие!")
        case .saveSettingsError:
            return NSLocalizedString("Ошибка сохранения настроек!", comment: "Попробуйте еще раз!")
        case .getSettingsError:
            return NSLocalizedString("Ошибка чтения настроек!", comment: "Попробуйте еще раз!")
       
        }
    }
}
