//
//  HeaderData.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol HeaderData {
	var height: CGFloat { get }
	func header(for tableView: UITableView, section: Int) -> UIView?
}

extension HeaderData {
	
	public func header(for tableView: UITableView, section: Int) -> UIView? {
		return nil
	}
}
