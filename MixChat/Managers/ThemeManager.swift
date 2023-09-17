//
//  ThemeManager.swift
//  MixChat
//
//  Created by Михаил Фокин on 11.03.2023.
//

import UIKit
import Foundation

protocol ThemesPickerDelegate: AnyObject {
	func updateStyle(style: UIUserInterfaceStyle)
	/// Возвращает текущую тему приложения.
	func currentStyle() -> UIUserInterfaceStyle
}

class ThemeManager: ThemesPickerDelegate {
	
	private let styleKey = "UserInterfaceStyle"
	
	func updateStyle(style: UIUserInterfaceStyle) {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			appDelegate.window?.overrideUserInterfaceStyle = style
			saveToUserDefaults(style: style)
		}
	}
	
	func currentStyle() -> UIUserInterfaceStyle {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			return appDelegate.window?.overrideUserInterfaceStyle ?? .light
		}
		return .light
	}
	
	/// Устанавливает сохраненное в UserDefaults тему 
	func setSavedUserInterfaceStyle() {
		let defaults = UserDefaults.standard
		let number = defaults.integer(forKey: self.styleKey)
		if let style = UIUserInterfaceStyle(rawValue: number) {
			updateStyle(style: style)
		}
	}
	
	private func saveToUserDefaults(style: UIUserInterfaceStyle) {
		let defaults = UserDefaults.standard
		defaults.set(style.rawValue, forKey: self.styleKey)
		defaults.synchronize()
	}
}
