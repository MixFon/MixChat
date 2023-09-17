//
//  DialogController.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit

protocol DialogDisplayLogic: AnyObject {
	func displayContent(show: DialogModel.ViewModel)
}

final class DialogController: UIViewController {
	
	var router: DialogRoutingLogic?
	var interactor: DialogBusinessLogic?
	private let mainView = DialogView()
	
	override func loadView() {
		self.view = self.mainView
		self.mainView.delegate = self
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.mainView.setNotification()
		self.navigationController?.navigationBar.isHidden = true

		self.interactor?.makeState(requst: .start)
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.interactor?.makeState(requst: .unsubscribe)
	}
}

extension DialogController: DialogDisplayLogic {
    
	func displayContent(show: DialogModel.ViewModel) {
		switch show {
		case .message(let tableData):
			DispatchQueue.main.async {
				self.mainView.configure(with: tableData)
			}
		case .interlocutor(let interlocutor):
			DispatchQueue.main.async {
				self.mainView.setupNavigationBar(interlocutor: interlocutor)
			}
		case .errorCheckMessage:
			DispatchQueue.main.async {
				self.mainView.shakeTextFieldView()
			}
		case .errorAlert(let textError):
			DispatchQueue.main.async {
				self.router?.presentAlertError(textError: textError)
			}
		}
	}
}

extension DialogController: DialogViewAction {
	
	func selectPhoto() {
		self.router?.selectPhotoFromNetwork()
	}
	
	func closeController() {
		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.popViewController(animated: true)
	}
	
	func sendMessage(text: String?) {
		self.interactor?.makeState(requst: .sendMessage(text))
	}
}

extension DialogController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
