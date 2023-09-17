//
//  DialogModels.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit
import TFSChatTransport

enum DialogModel {

    enum Request {
		case start
		case unsubscribe
		case sendMessage(String?)
    }
    
    enum Response {
		case messages([MessageProtocol]?)
		case errorAlert(String?)
		case interlocutor(Interlocutor?)
		case channelDeleted
		case errorCheckMessage
    }
    
    enum ViewModel {
		case message(TableData?)
		case errorAlert(String?)
		case interlocutor(Interlocutor?)
		case errorCheckMessage
    }
}
