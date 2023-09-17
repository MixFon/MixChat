//
//  Ext+UIView.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit

extension UIView {
	static func loadFromNib(_ bundle: Bundle? = nil) -> Self? {
		let nib = UINib(nibName: String(describing: self), bundle: bundle)
		return nib.instantiate(withOwner: nil, options: nil).first as? Self
	}
}
