//
//  EditProfileConfigurator.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit

final class EditProfileConfigurator {
	
	private let userProfile: UserProfileProtocol?
	private let storage: StorageProtocol?
	
	required init(userProfile: UserProfileProtocol?, storage: StorageProtocol?) {
		self.userProfile = userProfile
		self.storage = storage
	}
	
	func configure() -> UIViewController {
		let controller = EditProfileController()
		let presenter = EditProfilePresenter(controller: controller)
		let dependencies = EditProfileInteractor.Dependencies(
			storage: self.storage,
			presenter: presenter,
			userProfile: self.userProfile
		)
		let interactor = EditProfileInteractor(dependencies: dependencies)
		let router = EditProfileRouter(controller: controller)
		let choosePhotoManager = ChoosePhotoManager(controller: controller)
		choosePhotoManager.delegate = router
		router.choosePhotoManager = choosePhotoManager
		router.dataStore = interactor
		controller.interactor = interactor
		controller.router = router
		return controller
	}
}
