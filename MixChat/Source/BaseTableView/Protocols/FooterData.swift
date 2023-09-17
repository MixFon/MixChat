//
//  FooterData.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol FooterData {
	var height: CGFloat { get }
	func footer(for tableView: UITableView, section: Int) -> UIView?
}

extension FooterData {
	
	public func footer(for tableView: UITableView, section: Int) -> UIView? {
		return nil
	}
}
