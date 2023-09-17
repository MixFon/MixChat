//
//  ProfileViewController.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit
import Combine

protocol ProfileDisplayLogic: AnyObject {
	func displayContent(show: ProfileModel.ViewModel)
}

final class ProfileController: UIViewController {
	
	var router: ProfileRoutingLogic?
	var interactor: ProfileBusinessLogic?
	
	private lazy var mainView = ProfileView.loadFromNib()
	private lazy var logger = Logger()
	
	override func loadView() {
		self.view = mainView
		mainView?.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		/*
		 В методе viewDidLoad, когда представление только загружается, размеры и
		 положение кнопки ещё не были адаптированы к размерам экрана устройства.
		 Поэтому, значение свойства frame на этом этапе может не соответствовать
		 фактическому положению кнопки на экране.
		 */
		self.mainView?.setupNavigationItem(navigationItem: self.navigationItem)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.mainView?.setupNavigationBar(navigationBar: self.navigationController?.navigationBar)
		self.interactor?.makeState(requst: .fetch)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.mainView?.stopAnimations()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		/*
		 В методе viewDidAppear, после того, как представление было добавлено на экран,
		 его размеры и положение уже были скорректированы, чтобы соответствовать размеру
		 экрана устройства и другим факторам, таким как положение других представлений в
		 иерархии. Поэтому, значение свойства frame на этом этапе будет более точным и
		 актуальным.
		 */
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
}

extension ProfileController: ProfileDisplayLogic {
	
	func displayContent(show: ProfileModel.ViewModel) {
		switch show {
		case .display(let data):
			DispatchQueue.main.async {
				self.mainView?.configure(with: data)
			}
		case .presentEditProfile:
            DispatchQueue.main.async {
                self.router?.presentEditProfile()
            }
		}
	}
}

extension ProfileController: ProfileViewAction {
	func pressEdit() {
		self.router?.presentEditProfile()
	}
	
	func pressAddPhoto() {
		self.router?.choosePhoto()
	}
}
