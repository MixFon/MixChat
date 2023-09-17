//
//  CellData.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol CellData {
	var height: CGFloat? { get }
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath)
}
