//
//  ConversationConfigurator.swift
//  MixChat
//
//  Created by Михаил Фокин on 16.04.2023.
//

import UIKit
import TFSChatTransport

final class ConversationConfigurator {
	func configure() -> UIViewController {
		guard let host = Bundle.main.object(forInfoDictionaryKey: "TFS_HOST") as? String else {
			print("Не задан хост")
			return .init(nibName: nil, bundle: nil)
		}
		guard let portString = Bundle.main.object(forInfoDictionaryKey: "TFS_PORT") as? String else {
			print("Не задан порт")
			return .init(nibName: nil, bundle: nil)
		}
		guard let port = Int(portString) else {
			print("Неверная конвертация")
			return .init(nibName: nil, bundle: nil)
		}
			
		let controller = ConversationsController()
		let presenter = ConversationsPresenter(controller: controller)
		let dependencies = ConversationsInteractor.Dependencies(
			presenter: presenter,
			sseService: SSEService(host: host, port: port),
			chatService: ChatService(host: host, port: port),
			chatDataSource: ChatDataSource()
		)
		let interactor = ConversationsInteractor(dependencies: dependencies)
		let router = ConversationsRouter(controller: controller)
		router.dataStore = interactor
		controller.interactor = interactor
		controller.router = router
		return controller
	}
}
