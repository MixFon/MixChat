//
//  ProfileConfigurator.swift
//  MixChat
//
//  Created by Михаил Фокин on 17.04.2023.
//

import UIKit
import TFSChatTransport

final class ProfileConfigurator {
    
    func configure() -> UIViewController {
        let controller = ProfileController()
        let presenter = ProfilePresenter(controller: controller)
		
        let dependencies = ProfileInteractor.Dependencies(
            storage: GCDWorker(),
            presenter: presenter,
            userProfile: UserPrifile()
        )
        let interactor = ProfileInteractor(dependencies: dependencies)
		
        let router = ProfileRouter(controller: controller)
		let choosePhotoManager = ChoosePhotoManager(controller: controller)
		choosePhotoManager.delegate = router
		router.choosePhotoManager = choosePhotoManager
        router.dataStore = interactor
        controller.interactor = interactor
        controller.router = router
        return controller
    }
}
