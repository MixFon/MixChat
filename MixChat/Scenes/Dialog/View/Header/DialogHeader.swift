//
//  DialogHeader.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import Foundation
import UIKit

protocol DialogHeaderProtocol: HeaderData {
	var title: String? { get }
}

private enum Constants {
	static let margin: CGFloat = 16
}

extension DialogHeaderProtocol {

	var height: CGFloat {
		return 20
	}
	
	func header(for tableView: UITableView, section: Int) -> UIView? {
		tableView.register(DialogHeader.self, forHeaderFooterViewReuseIdentifier: DialogHeader.identifire)
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DialogHeader.identifire) as? DialogHeader else { return nil }
		header.configure(with: self)
		return header
	}
}

final class DialogHeader: UITableViewHeaderFooterView {
	
	private lazy var title: UILabel = {
		let title = UILabel(frame: .zero)
		title.font = UIFont.systemFont(ofSize: 11)
		title.textColor = .textSecondary
		title.textAlignment = .center
		return title
	}()
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		self.title.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(title)
		
		NSLayoutConstraint.activate([
			self.title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.margin),
			self.title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			self.title.trailingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: -Constants.margin)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with data: DialogHeaderProtocol?) {
		self.title.text = data?.title
	}
}
