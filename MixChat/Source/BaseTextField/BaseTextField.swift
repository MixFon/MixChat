//
//  BaseTextField.swift
//  MixChat
//
//  Created by Михаил Фокин on 17.03.2023.
//

import UIKit

class BaseTextField: UITextField {

	let padding = UIEdgeInsets(top: 11, left: 90, bottom: 11, right: 36)

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
}
