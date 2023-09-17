//
//  ConversationsHelper.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import Foundation

protocol ConversationsActions {
	func pressOnCell(interlocutor: Interlocutor)
    func deleteChannel(channelID: String?)
}

final class ConversationsHelper: TableHelperProtocol {
	
	private var actions: ConversationsActions?
	private var data: ConversationsSection?
	
	init(data: ConversationsSection? = nil, actions: ConversationsActions? = nil) {
		self.data = data
		self.actions = actions
	}
	
	func makeHeader() -> HeaderData? {
		if let header = self.data?.header {
			return ConversationsSectionHeaderModel(title: header)
		} else {
			return nil
		}
	}
	
	func makeElements() -> [CellData]? {
		var elements: [CellData] = []
		for element in self.data?.elements ?? [] {
			let cell: CellData
			cell = createCell(element: element)
			elements.append(cell)
		}
		return elements
	}
	
	/// Создает обычную ячейку
	private func createCell(element: ConversationsElement) -> CellData {
		let cell = ConversationCellModel(
			name: element.name,
			date: convertDateToString(date: element.date),
			message: element.message ?? "No messages yet",
			imageURL: element.imageURL,
			isOnline: element.isOnline,
			isNotMessage: false,
			hasUnreadMessages: element.hasUnreadMessages,
			onSelect: {
				let interlocutor = Interlocutor(
					id: element.id,
					name: element.name,
					imageURL: element.imageURL
				)
				self.actions?.pressOnCell(interlocutor: interlocutor)
			},
            onSwipedLeft: {
                self.actions?.deleteChannel(channelID: element.id)
            }
            
		)
		return cell
	}
	
	func makeFooter() -> FooterData? {
		return nil
	}
	
	func makeSection() -> SectionData? {
		let section = SectionDataModel(
			header: makeHeader(),
			elements: makeElements(),
			footer: makeFooter()
		)
		return section
	}
	
	private func convertDateToString(date: Date?) -> String? {
		guard let date else { return nil }
		let dateFormatter = DateFormatter()

		if Calendar.current.isDateInToday(date) {
			dateFormatter.dateFormat = "HH:mm"
		} else {
			dateFormatter.dateFormat = "MMM dd"
		}

		let dateString = dateFormatter.string(from: date)
		return dateString
	}
}
