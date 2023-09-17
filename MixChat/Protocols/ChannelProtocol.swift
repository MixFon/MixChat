//
//  ChannelProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.04.2023.
//

import Foundation

protocol ChannelProtocol {
    var id: String { get }
    var name: String { get }
    var logoURL: String? { get }
    var lastMessage: String? { get }
    var lastActivity: Date? { get }
}
