//
//  ProfileRouter.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit
import PhotosUI

protocol ProfileRoutingLogic {
	func choosePhoto()
	func presentEditProfile()
}

final class ProfileRouter: NSObject, ProfileRoutingLogic {
	
	private weak var controller: UIViewController?
	
	var dataStore: ProfileDataStore?
	var choosePhotoManager: ChoosePhotoManagerProtocol?
	
	init(controller: UIViewController? = nil) {
		self.controller = controller
	}
	
	func choosePhoto() {
		self.choosePhotoManager?.choosePhoto()
	}
	
	func presentEditProfile() {
		let userProfile = self.dataStore?.getUserPrifile()
		let storage = self.dataStore?.getStorage()
		let configurator = EditProfileConfigurator(userProfile: userProfile, storage: storage)
		let editProfile = configurator.configure()
		editProfile.modalPresentationStyle = .pageSheet
		self.controller?.navigationController?.delegate = self
		self.controller?.navigationController?.pushViewController(editProfile, animated: true)
	}
}

extension ProfileRouter: ChoosePhotoDelegate {
	func selectedImage(image: UIImage?) {
		self.dataStore?.setUserPhoto(image: image)
	}
}

extension ProfileRouter: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
		from fromVC: UIViewController,
		to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			if toVC is ProfileController {
				return nil
			}
			return TransitionManager(duration: 0.5)
		}
}
