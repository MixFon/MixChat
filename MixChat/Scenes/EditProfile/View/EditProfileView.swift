//
//  EditProfileView.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit

protocol EditProfileViewAction: AnyObject {
	func pressCancel()
	func pressAddPhoto()
	func pressSave(userName: String?, userBio: String?)
}

protocol EditProfileShow {
	var title: String? { get }
	var userProfile: UserProfileProtocol? { get }
	var rightButtonState: RightItem? { get }
	var isTextFieldsFirstResponder: Bool? { get }
}

final class EditProfileView: UIView {
	
	private var navigationBar: UINavigationBar!
	private var navigationItem: UINavigationItem!
	
	weak var delegate: EditProfileViewAction?
	
	private var onPressRightButton: (() -> Void)?
	
	private lazy var userPhoto: UIImageView = {
		let imageView = UIImageView()
		
		imageView.layer.cornerRadius = 150 / 2
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var addPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Add Photo", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
		button.addTarget(self, action: #selector(pressAddPhoto(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var userBioTextField: BaseTextField = {
		let textField = BaseTextField()
		textField.borderStyle = .roundedRect
		let bioView = UIView()
		let bio = UILabel()
		bio.text = "Bio"
		bio.translatesAutoresizingMaskIntoConstraints = false
		bioView.addSubview(bio)
		bio.leadingAnchor.constraint(equalTo: bioView.leadingAnchor, constant: 16).isActive = true
		bio.trailingAnchor.constraint(equalTo: bioView.trailingAnchor).isActive = true
		bio.centerYAnchor.constraint(equalTo: bioView.centerYAnchor).isActive = true
		textField.leftView = bioView
		textField.leftViewMode = .always
		return textField
	}()
	
	private lazy var userNameTextField: BaseTextField = {
		let textField = BaseTextField()
		textField.borderStyle = .roundedRect
		let nameView = UIView()
		let name = UILabel()
		name.text = "Name"
		name.translatesAutoresizingMaskIntoConstraints = false
		nameView.addSubview(name)
		name.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 16).isActive = true
		name.trailingAnchor.constraint(equalTo: nameView.trailingAnchor).isActive = true
		name.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
		textField.leftView = nameView
		textField.leftViewMode = .always
		return textField
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupUI()
	}
	
	private func setupUI() {
		self.backgroundColor = .backgroundSecondary
		[userPhoto, addPhotoButton, userBioTextField, userNameTextField].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		})
		
		NSLayoutConstraint.activate([
			userPhoto.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
			userPhoto.widthAnchor.constraint(equalToConstant: 150),
			userPhoto.heightAnchor.constraint(equalToConstant: 150),
			userPhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
			
			addPhotoButton.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 24),
			addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			
			userNameTextField.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
			userNameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			userNameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			
			userBioTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor),
			userBioTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			userBioTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
		])
	}
	
	func setupNavigationItem(navigationItem: UINavigationItem?) {
		self.navigationItem = navigationItem
		let close = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pressCancel(_:)))
		self.navigationItem.leftBarButtonItem = close
		let choice = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.pressSave(_:)))
		self.navigationItem.rightBarButtonItem = choice
	}
	
	func setupNavigationBar(navigationBar: UINavigationBar?) {
		self.navigationBar = navigationBar
		navigationBar?.shadowImage = UIImage()
		navigationBar?.backgroundColor = .backgroundSecondary
		navigationBar?.prefersLargeTitles = false
	}
	
	func configure(with data: EditProfileShow?) {
		self.navigationItem.title = data?.title
		self.setupTextFields(data: data)
		if let userPhoto = data?.userProfile?.userPhoto {
			self.userPhoto.image = userPhoto
		} else {
			let imageManager = ImageManager()
			self.userPhoto.image = imageManager.creatingImageByInitials(userName: data?.userProfile?.userName, size: 150)
		}
		self.setupRightButton(data: data)
	}
	
	private func setupTextFields(data: EditProfileShow?) {
		self.userBioTextField.text = data?.userProfile?.userBio
		self.userNameTextField.text = data?.userProfile?.userName
		if data?.isTextFieldsFirstResponder == true {
			self.userNameTextField.becomeFirstResponder()
		} else {
			self.userNameTextField.resignFirstResponder()
		}
		self.userNameTextField.isEnabled = data?.rightButtonState != .hidden
		self.userBioTextField.isEnabled = data?.rightButtonState != .hidden
		self.addPhotoButton.isEnabled = data?.rightButtonState != .hidden
	}
	
	private func setupRightButton(data: EditProfileShow?) {
		switch data?.rightButtonState {
		case .choice:
			let close = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pressCancel(_:)))
			self.navigationItem.leftBarButtonItem = close
			let choice = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.pressSave(_:)))
			self.navigationItem.rightBarButtonItem = choice
			self.navigationBar?.prefersLargeTitles = false
		case .hidden:
			let close = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pressCancel(_:)))
			self.navigationItem.leftBarButtonItem = close
			let indicator = UIActivityIndicatorView(style: .medium)
			indicator.startAnimating()
			let hidden = UIBarButtonItem(customView: indicator)
			self.navigationItem.rightBarButtonItem = hidden
		default:
			return
		}
	}
	
	// - MARK: - obc
	
	@objc
	func pressCancel(_ sender: AnyObject) {
		self.delegate?.pressCancel()
	}
	
	@objc
	func pressSave(_ sender: AnyObject) {
		self.delegate?.pressSave(userName: self.userNameTextField.text, userBio: self.userBioTextField.text)
	}
	
	@objc
	func pressAddPhoto(_ sender: AnyObject) {
		self.delegate?.pressAddPhoto()
	}
}
