//
//  Ext+UIColor.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

extension UIColor {
	
	// MARK: - Цвета текстов

	public static var textPrimary: UIColor {
		return UIColor(named: "TextPrimary", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var textSecondary: UIColor {
		return UIColor(named: "TextSecondary", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	// MARK: - Цвета фонов

	public static var backgroundGreen: UIColor {
		return UIColor(named: "BackgroundGreen", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var backgroundSecondary: UIColor {
		return UIColor(named: "BackgroundSecondary", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var backgroundPrimary: UIColor {
		return UIColor(named: "BackgroundPrimary", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var topNavigation: UIColor {
		return UIColor(named: "TopNavigation", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var bubblePrimary: UIColor {
		return UIColor(named: "BubblePrimary", in: .main, compatibleWith: .current) ?? .magenta
	}
	
	public static var bubbleSecondaty: UIColor {
		return UIColor(named: "BubbleSecondaty", in: .main, compatibleWith: .current) ?? .magenta
	}
}
