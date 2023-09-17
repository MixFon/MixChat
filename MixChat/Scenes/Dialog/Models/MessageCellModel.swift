//
//  MessageCellModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import Foundation

struct MessageCellModel: MessageCellProtocol {
	var time: String?
	var type: MessageType?
	var message: String?
	var hasTail: Bool?
}
