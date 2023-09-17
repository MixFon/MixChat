//
//  Ext+UICollectionViewCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 24.04.2023.
//

import UIKit

extension UICollectionViewCell {
	
	static func nib(_ bundle: Bundle? = nil) -> UINib {
		return UINib(nibName: identifire, bundle: bundle)
	}
	
	static var identifire: String {
		return String(describing: self)
	}
}
