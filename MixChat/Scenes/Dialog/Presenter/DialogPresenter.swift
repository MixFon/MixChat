//
//  DialogPresenter.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit
import TFSChatTransport

protocol DialogPresentationLogic: AnyObject {
	func buildState(response: DialogModel.Response)
}

final class DialogPresenter: DialogPresentationLogic {
    
	private weak var controller: DialogDisplayLogic?
	private let uuid: String
    
    init(controller: DialogDisplayLogic?) {
        self.controller = controller
		let keychainManager = KeychainManager()
		self.uuid = keychainManager.getUUIDFromKeychain() ?? "random string"
    }
    
	func buildState(response: DialogModel.Response) {
		switch response {
		case .messages(let messages):
			if messages?.isEmpty == true {
				createPlugState()
				return
			}
			var sections = [SectionData]()
			var date: Date? = messages?.first?.date
			var messagesInDay = [MessageProtocol]()
			for message in messages ?? [] {
				if date?.dayMonthYear() != message.date.dayMonthYear() {
					let helper = DialogHelper(dateMessage: date, data: messagesInDay, uuid: self.uuid)
					guard let section = helper.makeSection() else { continue }
					sections.append(section)
					messagesInDay.removeAll()
					date = message.date
				}
				messagesInDay.append(message)
			}
			if !messagesInDay.isEmpty {
				let helper = DialogHelper(dateMessage: date, data: messagesInDay, uuid: self.uuid)
				if let section = helper.makeSection() {
					sections.append(section)
				}
			}
			let tableData = TableDataModel(sections: sections)
			self.controller?.displayContent(show: .message(tableData))
		case .interlocutor(let interlocutor):
			self.controller?.displayContent(show: .interlocutor(interlocutor))
		case .errorCheckMessage:
			self.controller?.displayContent(show: .errorCheckMessage)
		case .errorAlert(let textError):
			self.controller?.displayContent(show: .errorAlert(textError))
		case .channelDeleted:
			channelHasBeenDeleted()
		}
	}
	
	private func createPlugState() {
		let element = PlugCellModel(title: "No messages yet")
		let section = SectionDataModel(
			header: nil,
			elements: [element],
			footer: nil
		)
		let tableData = TableDataModel(sections: [section])
		self.controller?.displayContent(show: .message(tableData))
	}
	
	/// Создает стейт при котором текущий канал был удален
	private func channelHasBeenDeleted() {
		let element = PlugCellModel(title: "The channel has been deleted.")
		let section = SectionDataModel(
			header: nil,
			elements: [element],
			footer: nil
		)
		let tableData = TableDataModel(sections: [section])
		self.controller?.displayContent(show: .message(tableData))
	}
}
