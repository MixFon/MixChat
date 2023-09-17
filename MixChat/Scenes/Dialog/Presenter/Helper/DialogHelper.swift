//
//  DialogHelper.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import Foundation
import TFSChatTransport

protocol DialogActions {
	
}

final class DialogHelper: TableHelperProtocol {

	private var data: [MessageProtocol]?
	private var actions: DialogActions?
	private var dateMessage: Date?
	private let uuid: String
	
	init(dateMessage: Date?, data: [MessageProtocol]?, actions: DialogActions? = nil, uuid: String) {
		self.dateMessage = dateMessage
		self.data = data
		self.actions = actions
		self.uuid = uuid
	}
	
	func makeHeader() -> HeaderData? {
		let header = DialogHeaderModel(title: convertDateToString(date: self.dateMessage, dateFormat: "MMM, dd"))
		return header
	}
	
	func makeElements() -> [CellData]? {
		var elements: [CellData] = []
		var currentID: String?
		var forTail: String?
		for message in self.data ?? [] {
			let element = determineCellType(message: message)
			if forTail != message.userID {
				if elements.last is MessageCellModel {
					if var lastElem = elements.popLast() as? MessageCellModel {
						lastElem.hasTail = true
						elements.append(lastElem)
					}
				}
				forTail = message.userID
			}
			if currentID != message.userID && self.uuid != message.userID {
				let name = NameCellModel(title: message.userName)
				elements.append(name)
				currentID = message.userID
			}
			elements.append(element)
		}
		if elements.last is MessageCellModel {
			if var lastElem = elements.popLast() as? MessageCellModel {
				lastElem.hasTail = true
				elements.append(lastElem)
			}
		}
		return elements
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
	
	private func determineCellType(message: MessageProtocol) -> CellData {
		if verifyUrl(urlString: message.text) {
			return buildImageCell(message: message)
		} else {
			return buildMessageCell(message: message)
		}
	}
	
	private func buildImageCell(message: MessageProtocol) -> CellData {
		let imageCellModel = ImageCellModel(
			time: convertDateToString(date: message.date, dateFormat: "HH:mm"),
			type: self.uuid == message.userID ? .user : .interlocutor,
			imageUrl: message.text
		)
		return imageCellModel
	}
	
	private func buildMessageCell(message: MessageProtocol) -> CellData {
		let messageCellModel = MessageCellModel(
			time: convertDateToString(date: message.date, dateFormat: "HH:mm"),
			type: self.uuid == message.userID ? .user : .interlocutor,
			message: message.text,
			hasTail: false
		)
		return messageCellModel
	}
	
	private func verifyUrl(urlString: String?) -> Bool {
		guard let urlString = urlString,
			  let url = URL(string: urlString) else {
			return false
		}
		return UIApplication.shared.canOpenURL(url)
	}
	
	private func convertDateToString(date: Date?, dateFormat: String) -> String? {
		guard let date else { return nil }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		let dateString = dateFormatter.string(from: date)
		return dateString
	}
}
