//
//  DialogInteractor.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import Combine
import Foundation
import TFSChatTransport

protocol DialogBusinessLogic: AnyObject {
	func makeState(requst: DialogModel.Request)
}

protocol DialogDataStore {
	var interlocutor: Interlocutor? { get set }
}

final class DialogInteractor: DialogBusinessLogic {
	
	private var presenter: DialogPresentationLogic?
	
	var interlocutor: Interlocutor?
	
	private let chatService: ChatServiceProtocol?
	private let sseService: SSEServiceProtocol?
	private let chatDataSource: ChatDataSourceProtocol?
	private let storage: StorageProtocol?
	private let userId: String
	private var userName: String?
	private var messages: [MessageProtocol]? = []
	
	private lazy var cancellable = Set<AnyCancellable>()
	
	struct Dependencies {
		let storage: StorageProtocol?
		let presenter: DialogPresentationLogic?
		let sseService: SSEServiceProtocol?
		let chatService: ChatServiceProtocol?
		let keychainManager: KeychainManagerProtocol?
		let chatDataSource: ChatDataSourceProtocol?
	}
	
	required init(dependencies: Dependencies) {
		self.storage = dependencies.storage
		self.sseService = dependencies.sseService
		self.presenter = dependencies.presenter
		self.chatService = dependencies.chatService
		self.chatDataSource = dependencies.chatDataSource
		
		self.userId = dependencies.keychainManager?.getUUIDFromKeychain() ?? String.getRandomString(lenth: 32)
		fetchUserName()
		subscribeOnEvents()
	}
	
	func makeState(requst: DialogModel.Request) {
		switch requst {
		case .start:
			self.presenter?.buildState(response: .interlocutor(self.interlocutor))
			fetchChannalMessagesWithCache()
		case .sendMessage(let text):
			checkMessage(text: text)
		case .unsubscribe:
			self.sseService?.cancelSubscription()
		}
	}
	
	private func checkMessage(text: String?) {
		guard let text else { return }
		if text.isEmpty {
			self.presenter?.buildState(response: .errorCheckMessage)
		} else {
			sendMessageToChannal(text: text)
		}
	}
	
	private func sendMessageToChannal(text: String) {
		guard let channelId = self.interlocutor?.id else { return }
		self.chatService?.sendMessage(
			text: text,
			channelId: channelId,
			userId: self.userId,
			userName: self.userName ?? "Unknown name"
		).sink { [weak self] result in
			switch result {
			case .failure(let error):
				self?.presenter?.buildState(response: .errorAlert(error.localizedDescription))
			case .finished:
				break
			}
		} receiveValue: { [weak self] message in
			print(message)
			self?.messages?.append(message)
			self?.saveMessage(message: message)
			self?.presenter?.buildState(response: .messages(self?.messages))
		}.store(in: &self.cancellable)
	}
	
	private func saveMessage(message: Message) {
		guard let id = self.interlocutor?.id else { return }
		self.chatDataSource?.saveMessage(channelID: id, message: message)
		self.chatDataSource?.updateChannel(channelID: id, message: message)
	}

	/// Получить сообщения. Спева сообщения достаются из DB. Потом делается запрос на сервер
	private func fetchChannalMessagesWithCache() {
		fetchChannalMessagesFromDB()
		fetchChannalMessagesFromServer()
	}
	
	/// Получить сообщения из DB
	private func fetchChannalMessagesFromDB() {
		guard let channelId = self.interlocutor?.id else { return }
		self.messages = self.chatDataSource?.getAllMesseges(with: channelId)
		self.presenter?.buildState(response: .messages(self.messages))
	}
	
	/// Получение списка сообщений с вервера
	private func fetchChannalMessagesFromServer() {
		guard let channelId = self.interlocutor?.id else { return }
		self.chatService?.loadMessages(channelId: channelId).sink { error in
			switch error {
			case .finished:
				break
			case .failure(let error):
				print(error.localizedDescription)
			}
		} receiveValue: { [weak self] received in
			self?.presenter?.buildState(response: .messages(received))
			self?.savedReceivedMessages(messages: received)
			self?.messages = received
		}.store(in: &self.cancellable)
	}
	
	private func savedReceivedMessages(messages: [MessageProtocol]) {
		guard let channelId = self.interlocutor?.id else { return }
		for message in messages {
			self.chatDataSource?.saveMessage(channelID: channelId, message: message)
		}
	}
	
	private func deleteUnnecessaryMessage(current: [MessageProtocol]?, received: [MessageProtocol]) {
		for message in current ?? [] {
			if !received.contains(where: { $0.id == message.id }) {
				self.chatDataSource?.deleteMessage(id: message.id)
			} else { continue }
		}
	}
	
	private func fetchUserName() {
		self.storage?.fetch(completion: { [weak self] result in
			switch result {
			case .success(let savedData):
				self?.userName = savedData.userName ?? "Unknown name"
			case .failure(let error):
				self?.userName = "Unknown name"
				print("Fetch failure!", error.localizedDescription)
			}
		})
	}
	
	private func subscribeOnEvents() {
		self.sseService?.subscribeOnEvents().sink { result in
			switch result {
			case .failure(let error):
				print(error)
			case .finished:
				print("finished")
			}
		} receiveValue: { [weak self] event in
			switch event.eventType {
			case .add:
				break
			case .delete:
				if event.resourceID == self?.interlocutor?.id {
					self?.messages = nil
					self?.presenter?.buildState(response: .channelDeleted)
					self?.chatDataSource?.deleteChannel(id: event.resourceID)
				}
				print("delete event \(event.resourceID)")
			case .update:
				if event.resourceID == self?.interlocutor?.id {
					self?.fetchChannalMessagesFromServer()
				}
			}
		}.store(in: &self.cancellable)
	}
}

extension DialogInteractor: DialogDataStore {

}
