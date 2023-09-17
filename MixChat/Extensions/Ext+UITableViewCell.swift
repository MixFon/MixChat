//
//  Ext+UITableViewCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

extension UITableViewCell {
	
	static func nib(_ bundle: Bundle? = nil) -> UINib {
		return UINib(nibName: identifire, bundle: bundle)
	}
	
	static var identifire: String {
		return String(describing: self)
	}
}
