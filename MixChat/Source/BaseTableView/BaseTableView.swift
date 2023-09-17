//
//  BaseTableView.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit
protocol TableData {
	var sections: [SectionData]? { get }
}

class BaseTableView: UITableView {
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		delegate = self
		dataSource = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var sections: [SectionData] = [] {
		didSet {
			self.reloadData()
		}
	}
	
	/// Переместить к самой нижней секции, к самой нижней ячеке
	func scrollToBottomTable() {
		let lastSection = self.numberOfSections - 1
		guard lastSection >= 0 else { return }
		let lastRow = self.numberOfRows(inSection: lastSection) - 1
		guard lastRow >= 0 else { return }
		let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
		
		self.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
	}
	
	func configure(with data: TableData?) {
		if let sections = data?.sections {
			self.sections = sections
		}
	}
}

extension BaseTableView: UITableViewDataSource {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.sections.isEmpty { return 0 }
		return self.sections[section].elements?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let element = self.sections[indexPath.section].elements?[indexPath.row] else { return .init() }
		return element.cell(for: tableView, indexPath: indexPath)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let element = self.sections[indexPath.section].elements?[indexPath.row] else { return }
		element.prepare(cell: cell, for: tableView, indexPath: indexPath)
	}

}

extension BaseTableView: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if self.sections.isEmpty { return .init(frame: .zero) }
		guard let headerData = self.sections[section].header else { return nil }
		return headerData.header(for: tableView, section: section)
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if self.sections.isEmpty { return nil }
		guard let footerData = self.sections[section].footer else { return nil }
		return footerData.footer(for: tableView, section: section)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if self.sections.isEmpty { return 44 }
		guard let element = self.sections[indexPath.section].elements?[indexPath.row] else { return 44 }
		return element.height ?? UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if self.sections.isEmpty { return 0 }
		guard let headerData = self.sections[section].header else { return 0 }
		return headerData.height
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if self.sections.isEmpty { return 0 }
		guard let footerData = self.sections[section].footer else { return 0 }
		return footerData.height
	}
	
}
