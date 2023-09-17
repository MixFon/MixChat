//
//  DialogRouter.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit

protocol DialogRoutingLogic {
	func presentAlertError(textError: String?)
	func selectPhotoFromNetwork()
}

final class DialogRouter: DialogRoutingLogic {
	
	private weak var controller: DialogController?
	
	var dataStore: DialogDataStore?
	
	init(controller: DialogController? = nil) {
		self.controller = controller
	}
	
	func presentAlertError(textError: String?) {
		let alert = UIAlertController(
			title: "Error",
			message: textError,
			preferredStyle: .alert
		)
		let cancel = UIAlertAction(title: "Oк", style: .cancel, handler: nil)
		alert.addAction(cancel)
		self.controller?.present(alert, animated: true, completion: nil)
	}
	
	func selectPhotoFromNetwork() {
		let configurator = ImagePickerConfigurator(pipe: self)
		let imagePickerController = configurator.configure()
		self.controller?.present(imagePickerController, animated: true)
	}
}

extension DialogRouter: ImagePickerPipe {
	
	func selectedImage(imageInfo: ImagePickerPipeModel?) {
		self.controller?.interactor?.makeState(requst: .sendMessage(imageInfo?.imageURL))
	}
}
