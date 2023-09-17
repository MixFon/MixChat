//
//  NameCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 06.04.2023.
//

import UIKit

protocol NameCellProtocol: CellData {
	var title: String? { get }
}

extension NameCellProtocol {
	
	var height: CGFloat? { return 12 }
	
	var backgroundColor: UIColor? { return nil }
	
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
		guard let cell = cell as? NameCell else { return }
		cell.configure(with: self)
	}
	
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		tableView.register(NameCell.self, forCellReuseIdentifier: NameCell.identifire)
		return tableView.dequeueReusableCell(withIdentifier: NameCell.identifire, for: indexPath) as? NameCell ?? .init()
	}
}

final class NameCell: UITableViewCell, ConfigurableViewProtocol {

	private lazy var title: UILabel = {
		let lable = UILabel()
		lable.font = UIFont.systemFont(ofSize: 11)
		lable.textColor = .textSecondary
		return lable
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .backgroundPrimary
		[title].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		})
		NSLayoutConstraint.activate([
			title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33),
			title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -33),
			title.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with data: NameCellProtocol?) {
		self.title.text = data?.title
	}
}
