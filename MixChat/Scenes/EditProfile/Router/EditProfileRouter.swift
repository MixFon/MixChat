//
//  EditProfileRouter.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit
import PhotosUI

protocol EditProfileRoutingLogic {
	func choosePhoto()
	func presentSuccessAlert()
	func presentFailureAlert()
	func dissmissController()
}

final class EditProfileRouter: NSObject, EditProfileRoutingLogic {
	
	private weak var controller: UIViewController?
	
	var dataStore: EditProfileDataStore?
	var choosePhotoManager: ChoosePhotoManagerProtocol?
	
	init(controller: UIViewController? = nil) {
		self.controller = controller
	}
	
	func choosePhoto() {
		self.choosePhotoManager?.choosePhoto()
	}
	
	func presentSuccessAlert() {
		let alertController = UIAlertController(title: "Success", message: "You are breathtaking", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		self.controller?.present(alertController, animated: true, completion: nil)
	}
	
	func presentFailureAlert() {
		let alertController = UIAlertController(title: "Could not save profile", message: "Try again", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel) { [weak self] _ in
			self?.dataStore?.tryAgainSaveData()
		}
		alertController.addAction(okAction)
		alertController.addAction(tryAgainAction)
		self.controller?.present(alertController, animated: true, completion: nil)
	}
	
	func dissmissController() {
		self.controller?.navigationController?.popViewController(animated: true)
	}
}

extension EditProfileRouter: ChoosePhotoDelegate {
	func selectedImage(image: UIImage?) {
		self.dataStore?.setUserPhoto(image: image)
	}
}
