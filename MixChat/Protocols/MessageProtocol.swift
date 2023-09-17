//
//  MessageProtocol.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.04.2023.
//

import Foundation

protocol MessageProtocol {
    var id: String { get }
    var text: String { get }
    var date: Date { get }
    var userID: String { get }
    var userName: String { get }
}
