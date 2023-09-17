//
//  ImagePickerConfigurator.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

import UIKit

final class ImagePickerConfigurator {
	
	private let pipe: ImagePickerPipe?
	
	init(pipe: ImagePickerPipe?) {
		self.pipe = pipe
	}
	
	func configure() -> UIViewController {
		let controller = ImagePickerController()
		let presenter = ImagePickerPresenter(controller: controller)
		let interactor = ImagePickerInteractor(presenter: presenter)
		let router = ImagePickerRouter(controller: controller)
		router.dataStore = interactor
		router.pipe = self.pipe
		controller.interactor = interactor
		controller.router = router
		return controller
	}
}
