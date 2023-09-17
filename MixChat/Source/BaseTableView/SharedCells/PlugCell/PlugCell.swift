//
//  PlugCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 13.04.2023.
//

import UIKit
import Foundation

private enum Constants {
	static let fontSize: CGFloat = 18
}

protocol PlugCellProtocol: CellData {
	var title: String? { get }
}

extension PlugCellProtocol {
	
	var height: CGFloat? { return calculateHeight(text: self.title ?? "") }
	
	var backgroundColor: UIColor? { return nil }
	
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
		guard let cell = cell as? PlugCell else { return }
		cell.configure(with: self)
	}
	
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		tableView.register(PlugCell.self, forCellReuseIdentifier: PlugCell.identifire)
		return tableView.dequeueReusableCell(withIdentifier: PlugCell.identifire, for: indexPath) as? PlugCell ?? .init()
	}
	
	private func calculateHeight(text: String) -> CGFloat {
		let leftMargin = 16.0
		let rightMargin = 16.0
		let topMargin = 16.0
		let bottomMargin = 16.0
		let finalWidth = UIScreen.main.bounds.width - leftMargin - rightMargin
		let titleSize = height(text: text, width: finalWidth, font: UIFont.systemFont(ofSize: Constants.fontSize))
		return topMargin + titleSize + bottomMargin
	}
	
	private func height(text: String, width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = text.boundingRect(
			with: constraintRect,
			options: .usesLineFragmentOrigin,
			attributes: [NSAttributedString.Key.font: font],
			context: nil
		)
		return ceil(boundingBox.height)
	}
}

final class PlugCell: UITableViewCell, ConfigurableViewProtocol {

	private lazy var title: UILabel = {
		let lable = UILabel()
		lable.font = UIFont.systemFont(ofSize: Constants.fontSize)
		lable.textColor = .textSecondary
		lable.numberOfLines = 0
		lable.textAlignment = .center
		return lable
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .backgroundPrimary
		self.selectionStyle = .none
		[title].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		})
		NSLayoutConstraint.activate([
			title.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
			title.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -16),
			title.centerYAnchor.constraint(equalTo: centerYAnchor),
			title.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func configure(with data: PlugCellProtocol?) {
		self.title.text = data?.title
		self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
	}
}
