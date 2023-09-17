//
//  MessageModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.04.2023.
//

import Foundation

struct MessageModel: MessageProtocol {
    var id: String
    var text: String
    var date: Date
    var userID: String
    var userName: String

}
