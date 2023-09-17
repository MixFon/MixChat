//
//  ConversationsDialogProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import Foundation

protocol ConversationsDialogProtocol {
	var name: String? { get }
	var message: String? { get }
	var imageURL: String? { get }
	var isOnline: Bool? { get }
	var hasUnreadMessages: Bool? { get }
}
