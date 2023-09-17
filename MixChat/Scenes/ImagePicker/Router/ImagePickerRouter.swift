//
//  ImagePickerRouter.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

import UIKit

protocol ImagePickerPipe {
	func selectedImage(imageInfo: ImagePickerPipeModel?)
}

protocol ImagePickerRoutingLogic {
	func selectedImage(imageInfo: ImagePickerPipeModel?)
	func presentFailureAlert(errorMessage: String?)
	func closeController()
}

final class ImagePickerRouter: ImagePickerRoutingLogic {
	
	private weak var controller: UIViewController?
	
	var pipe: ImagePickerPipe?
	
	var dataStore: ImagePickerDataStore?
	
	init(controller: UIViewController? = nil) {
		self.controller = controller
	}
	
	func selectedImage(imageInfo: ImagePickerPipeModel?) {
		self.pipe?.selectedImage(imageInfo: imageInfo)
		self.controller?.dismiss(animated: true)
	}
	
	func closeController() {
		self.controller?.dismiss(animated: true)
	}
	
	func presentFailureAlert(errorMessage: String?) {
		let alertController = UIAlertController(title: "Something went wrong", message: errorMessage, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		self.controller?.present(alertController, animated: true, completion: nil)
	}
}
