//
//  ConversationsListView.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol ConversationsShow {
	var title: String? { get }
	var tableData: TableData? { get }
}

protocol ConversationsViewAction: AnyObject {
	func pressOnSettings()
	func pressOnAddChannal()
	func refreshCannels()
}

final class ConversationsView: UIView {
	
	weak var delegate: ConversationsViewAction?
	
	private var navigationItem: UINavigationItem?
	private let refreshControl = UIRefreshControl()
	
	private lazy var table: BaseTableView = {
		let table = BaseTableView(frame: .zero, style: .plain)
		table.backgroundColor = .backgroundPrimary
		table.separatorInset = .init(top: 0, left: 73, bottom: 0, right: 0)
		refreshControl.attributedTitle = NSAttributedString(string: "Updating channels.")
		refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
		table.addSubview(refreshControl)
		return table
	}()
	
	@objc
	func refresh(_ sender: AnyObject) {
		print("refresh")
		self.delegate?.refreshCannels()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	private func setupView() {
		self.backgroundColor = .backgroundPrimary
		table.translatesAutoresizingMaskIntoConstraints = false
		addSubview(table)
		
		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			table.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			table.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	func configure(with data: ConversationsShow?) {
		self.refreshControl.endRefreshing()
		self.table.configure(with: data?.tableData)
		self.navigationItem?.title = data?.title
	}
	
	func setupNavigationItem(navigationItem: UINavigationItem?) {
		self.navigationItem = navigationItem
		let rightButton = UIBarButtonItem(title: "Add Channel", style: .plain, target: self, action: #selector(pressOnRightButton))
		self.navigationItem?.rightBarButtonItem = rightButton
	}
	
	@objc
	private func pressOnLertButton() {
		self.delegate?.pressOnSettings()
	}
	
	@objc
	private func pressOnRightButton() {
		self.delegate?.pressOnAddChannal()
	}
	
}
