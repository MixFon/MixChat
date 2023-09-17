//
//  ChannelModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.04.2023.
//

import Foundation

struct ChannelModel: ChannelProtocol, Hashable {
    var id: String
    var name: String
    var logoURL: String?
    var lastMessage: String?
    var lastActivity: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ChannelModel, rhs: ChannelModel) -> Bool {
        lhs.id == rhs.id
    }
}
