//
//  ConversationCellModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import Foundation

struct ConversationCellModel: ConversationCellProtocol {
	var name: String?
	var date: String?
	var message: String?
	var imageURL: String?
	var isOnline: Bool?
	var isNotMessage: Bool?
	var hasUnreadMessages: Bool?
	var onSelect: (() -> Void)?
	var onSwipedLeft: (() -> Void)?
}
