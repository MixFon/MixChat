//
//  ConversationsController.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol ConversationsDisplayLogic: AnyObject {
    func displayContent(show: ConversationsModel.ViewModel)
}

final class ConversationsController: UIViewController {
    
    var router: ConversationsListRoutingLogic?
	var interactor: ConversationsBusinessLogic?
    private lazy var mainView = ConversationsView()
    
    override func loadView() {
        self.view = mainView
        self.mainView.delegate = self
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.mainView.setupNavigationItem(navigationItem: self.navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.makeState(requst: .refresh)
    }
    
}

extension ConversationsController: ConversationsDisplayLogic {
    
    func displayContent(show: ConversationsModel.ViewModel) {
        switch show {
        case .display(let data):
			DispatchQueue.main.async {
				self.mainView.configure(with: data)
			}
        case .presentInterlocutor(let interlocutor):
			DispatchQueue.main.async {
				self.router?.presentDialogController(interlocutor: interlocutor)
			}
        case .alertError(let error):
			DispatchQueue.main.async {
				self.router?.presentAlertError(error: error)
			}
        case .deleteChennal(let channelID):
            self.interactor?.makeState(requst: .deleteChannel(channelID))
        }
    }
}

extension ConversationsController: ConversationsViewAction {
    func pressOnSettings() {
        self.router?.presentThemeViewController()
    }
    
    func pressOnAddChannal() {
        self.router?.presentAlertToAddCannel()
    }
    
    func refreshCannels() {
        self.interactor?.makeState(requst: .refresh)
    }
    
}
