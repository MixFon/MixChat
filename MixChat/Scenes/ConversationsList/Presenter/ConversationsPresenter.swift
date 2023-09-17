//
//  ConversationsPresenter.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit
import TFSChatTransport

protocol ConversationsPresentationLogic: AnyObject {
	func buildState(response: ConversationsModel.Response)
}

final class ConversationsPresenter: ConversationsPresentationLogic {
    
	private weak var controller: ConversationsDisplayLogic?
    
    init(controller: ConversationsDisplayLogic?) {
        self.controller = controller
    }
    
	func buildState(response: ConversationsModel.Response) {
		switch response {
		case .start:
			let show = ConversationsModel.ViewModel.Show(
				title: "Channels"
			)
			self.controller?.displayContent(show: .display(show))
		case .channals(let channels):
			if channels?.isEmpty == true {
				createPlugState()
				return
			}
			var sections = [SectionData]()
			let sortedChannels = sortedChannelToTime(channels: channels)
			let prepareSection = convertChannalToElementTable(channels: sortedChannels ?? [])
			let helper = ConversationsHelper(data: prepareSection, actions: self)
			if let section = helper.makeSection() {
				sections.append(section)
			}
			let tableData = TableDataModel(sections: sections)
			let show = ConversationsModel.ViewModel.Show(
				title: "Channels",
				tableData: tableData
			)
			self.controller?.displayContent(show: .display(show))
		case .alertError(let error):
			self.controller?.displayContent(show: .alertError(error))
		}
	}
	
	private func sortedChannelToTime(channels: [ChannelProtocol]?) -> [ChannelProtocol]? {
		guard let channels else { return nil }
		return channels.sorted { one, two in
			let timeOne = one.lastActivity?.timeIntervalSince1970 ?? -1
			let timeTwo = two.lastActivity?.timeIntervalSince1970 ?? -1
			return timeOne > timeTwo
		}
	}
	
	private func convertChannalToElementTable(channels: [ChannelProtocol]) -> ConversationsSection {
		var elements = [ConversationsElement]()
		for channel in channels {
			let element = ConversationsElement(
				id: channel.id,
				date: channel.lastActivity,
				name: channel.name,
				message: channel.lastMessage,
				imageURL: channel.logoURL,
				isOnline: nil,
				hasUnreadMessages: nil
			)
			elements.append(element)
		}
		let section = ConversationsSection(
			header: nil,
			elements: elements,
			footer: nil
		)
		return section
	}
	
	private func createPlugState() {
		let element = PlugCellModel(title: "No channels yet")
		let section = SectionDataModel(
			header: nil,
			elements: [element],
			footer: nil
		)
		let tableData = TableDataModel(sections: [section])
		let show = ConversationsModel.ViewModel.Show(
			title: "Channels",
			tableData: tableData
		)
		self.controller?.displayContent(show: .display(show))
	}
}

extension ConversationsPresenter: ConversationsActions {
	func pressOnCell(interlocutor: Interlocutor) {
		self.controller?.displayContent(show: .presentInterlocutor(interlocutor))
	}
    
    func deleteChannel(channelID: String?) {
        self.controller?.displayContent(show: .deleteChennal(channelID))
    }
}
