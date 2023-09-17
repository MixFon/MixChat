//
//  ConversationsListInteractor.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit
import Combine
import Foundation
import TFSChatTransport

protocol ConversationsBusinessLogic: AnyObject {
	func makeState(requst: ConversationsModel.Request)
}

protocol ConversationsDataStore {
	func addNewChannel(channalName: String?)
	func addNewChannelWithoutLogo(channalName: String?)
}

final class ConversationsInteractor: ConversationsBusinessLogic {
	
	private var channals: [ChannelProtocol] = []
	private let presenter: ConversationsPresentationLogic?
	private let sseService: SSEServiceProtocol?
	private let chatService: ChatServiceProtocol?
	private let chatDataSource: ChatDataSourceProtocol?
	private lazy var cancellable = Set<AnyCancellable>()
	
	struct Dependencies {
		let presenter: ConversationsPresentationLogic?
		let sseService: SSEServiceProtocol?
		let chatService: ChatServiceProtocol?
		let chatDataSource: ChatDataSourceProtocol?
	}
	
	init(dependencies: Dependencies) {
		self.presenter = dependencies.presenter
		self.sseService = dependencies.sseService
		self.chatService = dependencies.chatService
		self.chatDataSource = dependencies.chatDataSource
		subscribeOnEvents()
    }
    
    func makeState(requst: ConversationsModel.Request) {
        switch requst {
        case .refresh:
            getChannels()
        case .deleteChannel(let channelID):
            deleteChannel(channelID: channelID)
        }
	}
	
	private func getChannels() {
        self.channals = self.chatDataSource?.getAllChannels() ?? []
        self.presenter?.buildState(response: .channals(self.channals))
		self.chatService?.loadChannels().sink { [weak self] error in
			switch error {
			case .failure(let error):
				self?.presenter?.buildState(response: .alertError(error.localizedDescription))
			case .finished:
				break
			}
		} receiveValue: { [weak self] received in
            self?.presenter?.buildState(response: .channals(received))
            self?.deleteUnnecessaryChannels(current: self?.channals, received: received)
            self?.savedReceivedChannels(receivedChannels: received)
            self?.channals = received
		}.store(in: &self.cancellable)
	}
    
    private func savedReceivedChannels(receivedChannels: [ChannelProtocol]) {
        for channal in receivedChannels {
            self.chatDataSource?.saveChannel(with: channal)
        }
    }
    
    private func deleteUnnecessaryChannels(current: [ChannelProtocol]?, received: [ChannelProtocol]) {
        for channel in current ?? [] {
            if !received.contains(where: { $0.id == channel.id }) {
                self.chatDataSource?.deleteChannel(id: channel.id)
            } else { continue }
        }
    }
    
	private func createNewChannal(channalName: String, logoUrl: String? = nil) {
		self.chatService?.createChannel(name: channalName, logoUrl: logoUrl).sink { [weak self] error in
			switch error {
			case .failure(let error):
				self?.presenter?.buildState(response: .alertError(error.localizedDescription))
			case .finished:
				break
			}
		} receiveValue: { [weak self] channal in
			self?.channals.append(channal)
			self?.presenter?.buildState(response: .channals(self?.channals))
		}.store(in: &self.cancellable)
	}
	
	private func fetchDogImage(channalName: String) {
		guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
		URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: DogImage.self, decoder: JSONDecoder())
			.sink(receiveCompletion: { result in
				switch result {
				case .failure(let error):
					self.createNewChannal(channalName: channalName)
					print("Error: \(error)")
				case .finished:
					print("Finished")
				}
			}, receiveValue: { posts in
				self.createNewChannal(channalName: channalName, logoUrl: posts.message)
            }).store(in: &self.cancellable)
    }
    
    private func deleteChannel(channelID: String?) {
        guard let channelID else { return }
        self.chatService?.deleteChannel(id: channelID).sink { [weak self] error in
            switch error {
            case .failure:
                let description = "An error occurred when deleting the channel."
                self?.presenter?.buildState(response: .alertError(description))
            case .finished:
                break
            }
        } receiveValue: { [weak self] _ in
			self?.chatDataSource?.deleteChannel(id: channelID)
			self?.deleteChannelFromCurrent(channelID: channelID)
        }.store(in: &self.cancellable)
    }
	
	private func deleteChannelFromCurrent(channelID: String) {
		self.channals.removeAll(where: { $0.id == channelID })
		self.presenter?.buildState(response: .channals(self.channals))
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
				self?.makeState(requst: .refresh)
				print("add event \(event.resourceID)")
			case .delete:
				self?.makeState(requst: .refresh)
				print("delete event \(event.resourceID)")
			case .update:
				print("update event \(event.resourceID)")
			}
		}.store(in: &self.cancellable)
	}
}

extension ConversationsInteractor: ConversationsDataStore {
	
	func addNewChannel(channalName: String?) {
		guard let channalName, !channalName.isEmpty else {
			let errorMessate = "The channel name should not be empty."
			self.presenter?.buildState(response: .alertError(errorMessate))
			return
		}
		fetchDogImage(channalName: channalName)
	}
	
	func addNewChannelWithoutLogo(channalName: String?) {
		guard let channalName, !channalName.isEmpty else {
			let errorMessate = "The channel name should not be empty."
			self.presenter?.buildState(response: .alertError(errorMessate))
			return
		}
		self.createNewChannal(channalName: channalName)
	}
}

struct DogImage: Codable {
	let message: String?
	let status: String?
}
