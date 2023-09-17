//
//  ConversationsSectionHeader.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol ConversationsSectionHeaderProtocol: HeaderData {
	var title: String? { get }
}

private enum Constants {
	static let margin: CGFloat = 16
}

extension ConversationsSectionHeaderProtocol {

	var height: CGFloat {
		return 20
	}
	
	func header(for tableView: UITableView, section: Int) -> UIView? {
		tableView.register(ConversationsSectionHeader.self, forHeaderFooterViewReuseIdentifier: ConversationsSectionHeader.identifire)
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ConversationsSectionHeader.identifire) as? ConversationsSectionHeader else {
			return nil
		}
		header.configure(with: self)
		return header
	}
}

final class ConversationsSectionHeader: UITableViewHeaderFooterView, ConfigurableViewProtocol {
	
	private lazy var title: UILabel = {
		let title = UILabel(frame: .zero)
		title.font = UIFont.systemFont(ofSize: 15)
		title.textColor = .textSecondary
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
	
	func configure(with data: ConversationsSectionHeaderProtocol?) {
		self.title.text = data?.title
	}
}
