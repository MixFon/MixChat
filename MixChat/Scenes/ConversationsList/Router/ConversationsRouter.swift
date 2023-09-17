//
//  ConversationsListRouter.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit
import Combine

protocol ConversationsListRoutingLogic {
	func presentThemeViewController()
	func presentDialogController(interlocutor: Interlocutor?)
	func presentAlertToAddCannel()
	func presentAlertError(error: String?)
}

final class ConversationsRouter: NSObject, ConversationsListRoutingLogic {
	
	private weak var controller: UIViewController?
	
	private var action: UIAlertAction?
	
	var dataStore: ConversationsDataStore?
	
	init(controller: UIViewController? = nil) {
		self.controller = controller
	}
	
	func presentDialogController(interlocutor: Interlocutor?) {
		let configurator = DialogConfigurator()
		let controller = configurator.configure(interlocutor: interlocutor)
		self.controller?.navigationController?.pushViewController(controller, animated: true)
	}
	
	func presentThemeViewController() {
		let themeManager = ThemeManager()
		let themeController = ThemeViewController(themeDelegate: themeManager)
		self.controller?.navigationController?.pushViewController(themeController, animated: true)
	}
	
	func presentAlertToAddCannel() {
		let alertController = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)

		alertController.addTextField { (textField: UITextField?) -> Void in
			textField?.placeholder = "Channel Name"
		}

		let saveAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
			let textField = alertController.textFields?.first as? UITextField
			if let text = textField?.text {
				self.dataStore?.addNewChannel(channalName: text)
			}
		})
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancel)
		alertController.addAction(saveAction)
		self.action = saveAction
		self.controller?.present(alertController, animated: true, completion: nil)
	}
	
	func presentAlertError(error: String?) {
		let alert = UIAlertController(
			title: "Error",
			message: error,
			preferredStyle: .alert
		)
		let cancel = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
		alert.addAction(cancel)
		
		self.controller?.present(alert, animated: true, completion: nil)
	}
}
