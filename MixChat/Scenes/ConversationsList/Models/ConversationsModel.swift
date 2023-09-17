//
//  ConversationsModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit
import TFSChatTransport

enum ConversationsModel {
	
    enum Request {
		case refresh
        case deleteChannel(String?)
    }
    
    enum Response {
		case start
		case channals([ChannelProtocol]?)
		case alertError(String?)
    }
    
    enum ViewModel {
		case display(ConversationsShow)
        case alertError(String?)
        case deleteChennal(String?)
        case presentInterlocutor(Interlocutor)
		
		struct Show: ConversationsShow {
			var title: String?
			var tableData: TableData?
		}
    }
}
