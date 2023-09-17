//
//  ChatSource.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.04.2023.
//

import CoreData
import Foundation
import TFSChatTransport

protocol ChatDataSourceProtocol: AnyObject {
    func getAllChannels() -> [ChannelProtocol]
	func getAllMesseges(with channelID: String) -> [MessageProtocol]
    func saveChannel(with channel: ChannelProtocol)
    func deleteChannel(with channel: ChannelProtocol)
    func deleteChannel(id: String)
    func deleteMessage(id: String)
	func updateChannel(channelID: String, message: MessageProtocol)
    func saveMessage(channelID: String, message: MessageProtocol)
}

class ChatDataSource: ChatDataSourceProtocol {
   
    private var coreData: CoreDataServiceProtocol?
	private lazy var logger = Logger(isLogging: false)
    
    init(coreData: CoreDataServiceProtocol? = CoreDataService()) {
        self.coreData = coreData
    }
    
    func getAllChannels() -> [ChannelProtocol] {
        do {
            let dbCannals = try self.coreData?.fetchDBChannels()
            var channels = [ChannelModel]()
            for dbCannal in dbCannals ?? [] {
                guard
                    let id = dbCannal.id,
                    let name = dbCannal.name
                else {
                    continue
                }
                let channelModel = ChannelModel(
                    id: id,
                    name: name,
                    logoURL: dbCannal.logoURL,
                    lastMessage: dbCannal.lastMessage,
                    lastActivity: dbCannal.lastActivity
                )
                channels.append(channelModel)
            }
            return channels
        } catch {
			self.logger.log(error.localizedDescription)
        }
        return []
    }
	
	func getAllMesseges(with channelID: String) -> [MessageProtocol] {
		do {
			let dbMessages = try self.coreData?.fetchDBMessages(for: channelID)
			var messeges = [MessageProtocol]()
			for dbMessage in dbMessages ?? [] {
				guard
					let id = dbMessage.id,
					let text = dbMessage.text,
					let date = dbMessage.date,
					let userID = dbMessage.userID,
					let userName = dbMessage.userName
				else {
					continue
				}
				let messageModel = MessageModel(
					id: id,
					text: text,
					date: date,
					userID: userID,
					userName: userName
				)
				messeges.append(messageModel)
			}
			return messeges
		} catch {
			self.logger.log(error.localizedDescription)
		}
		return []
	}
    
    func saveChannel(with channel: ChannelProtocol) {
        self.coreData?.save { [weak self] context in
            let dbChannel = DBChannel(context: context)
            dbChannel.id = channel.id
            dbChannel.name = channel.name
            dbChannel.logoURL = channel.logoURL
            dbChannel.lastMessage = channel.lastMessage
            dbChannel.lastActivity = channel.lastActivity
            dbChannel.messages = NSOrderedSet()
			context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			self?.logger.log("Save channel with \(channel.id)")
        }
    }
    
    func deleteChannel(with channel: ChannelProtocol) {
        deleteChannel(id: channel.id)
    }
    
    func deleteChannel(id channelID: String) {
        self.coreData?.delete { [weak self] context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
            let dbChannel = try context.fetch(fetchRequest).first
            guard let dbChannel else { return }
            context.delete(dbChannel)
			self?.logger.log("Delete channel with \(channelID)")
        }
    }
	
	func deleteMessage(id messageID: String) {
        self.coreData?.delete { [weak self] context in
            let fetchRequest = DBMessage.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", messageID as CVarArg)
            let dbMessage = try context.fetch(fetchRequest).first
            guard let dbMessage else { return }
            context.delete(dbMessage)
			self?.logger.log("Delete message with \(messageID)")
        }
	}
	
	func updateChannel(channelID: String, message: MessageProtocol) {
		self.coreData?.save { [weak self] context in
			let fetchRequest = DBChannel.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
			let dbChannel = try context.fetch(fetchRequest).first
			guard let dbChannel else { return }
			dbChannel.lastMessage = message.text
			dbChannel.lastActivity = message.date
			self?.logger.log("Update chnnel with \(channelID)")
		}
	}
    
	func saveMessage(channelID: String, message: MessageProtocol) {
        self.coreData?.save { [weak self] context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
            let dbChannel = try context.fetch(fetchRequest).first
            guard let dbChannel else { return }
			
            let dbMessage = DBMessage(context: context)
            dbMessage.id = message.id
            dbMessage.date = message.date
            dbMessage.text = message.text
            dbMessage.userID = message.userID
            dbMessage.userName = message.userName
            dbChannel.addToMessages(dbMessage)
			context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			self?.logger.log("Save message with \(message.id) for channel \(channelID)")
        }
    }
    
}
