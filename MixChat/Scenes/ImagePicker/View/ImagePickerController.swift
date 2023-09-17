//
//  ImagePickerController.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

import UIKit

protocol ImagePickerDisplayLogic: AnyObject {
	func displayContent(show: ImagePickerModel.ViewModel)
}

final class ImagePickerController: UIViewController {

	var router: ImagePickerRoutingLogic?
	var interactor: ImagePickerBusinessLogic?
	private lazy var mainView = ImagePickerView()
	
	override func loadView() {
		self.view = mainView
		self.mainView.delegate = self
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.interactor?.makeState(requst: .start)
    }
    
}

extension ImagePickerController: ImagePickerDisplayLogic {
    
	func displayContent(show: ImagePickerModel.ViewModel) {
		switch show {
		case .display(let show):
			DispatchQueue.main.async {
				self.mainView.configure(with: show)
			}
		case .selectImage(let imageInfo):
			DispatchQueue.main.async {
				self.router?.selectedImage(imageInfo: imageInfo)
			}
		case .showError(let errorMessage):
			DispatchQueue.main.async {
				self.router?.presentFailureAlert(errorMessage: errorMessage)
			}
		}
	}
}

extension ImagePickerController: ImagePickerAction {
	func pressCancel() {
		self.router?.closeController()
	}
}
