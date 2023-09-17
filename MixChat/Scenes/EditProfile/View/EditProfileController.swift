//
//  EditProfileController.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit

protocol EditProfileDisplayLogic: AnyObject {
	func displayContent(show: EditProfileModel.ViewModel)
}

final class EditProfileController: UIViewController {
	
	var router: EditProfileRoutingLogic?
	var interactor: EditProfileBusinessLogic?
	private lazy var mainView = EditProfileView()
	
	override func loadView() {
		self.view = self.mainView
		self.mainView.delegate = self
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.mainView.setupNavigationBar(navigationBar: self.navigationController?.navigationBar)
		self.mainView.setupNavigationItem(navigationItem: self.navigationItem)
		self.interactor?.makeState(requst: .edit)
    }
    
}

extension EditProfileController: EditProfileDisplayLogic {
    
	func displayContent(show: EditProfileModel.ViewModel) {
		switch show {
		case .display(let show):
			DispatchQueue.main.async {
				self.mainView.configure(with: show)
			}
		case .savedSeccess:
			DispatchQueue.main.async {
				self.router?.presentSuccessAlert()
			}
		case .savedFailure:
			DispatchQueue.main.async {
				self.router?.presentFailureAlert()
			}
		}
	}
}

extension EditProfileController: EditProfileViewAction {
	func pressCancel() {
		self.interactor?.makeState(requst: .cancel)
		self.router?.dissmissController()
	}
	
	func pressAddPhoto() {
		self.router?.choosePhoto()
	}
	
	func pressSave(userName: String?, userBio: String?) {
		self.interactor?.makeState(requst: .saveNameBio(userName, userBio))
	}
	
}
