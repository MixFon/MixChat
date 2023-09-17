//
//  DialogConfigurator.swift
//  MixChat
//
//  Created by Михаил Фокин on 16.04.2023.
//

import UIKit
import TFSChatTransport

final class DialogConfigurator {
	
	func configure(interlocutor: Interlocutor?) -> UIViewController {
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
		
		let controller = DialogController()
		let presenter = DialogPresenter(controller: controller)
		
		let dependencies = DialogInteractor.Dependencies(
			storage: GCDWorker(),
			presenter: presenter,
			sseService: SSEService(host: host, port: port),
			chatService: ChatService(host: host, port: port),
			keychainManager: KeychainManager(),
			chatDataSource: ChatDataSource(coreData: CoreDataService())
		)
		let interactor = DialogInteractor(dependencies: dependencies)
		let router = DialogRouter(controller: controller)
		router.dataStore = interactor
		router.dataStore?.interlocutor = interlocutor
		controller.interactor = interactor
		controller.router = router
		return controller
	}
}
