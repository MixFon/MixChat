//
//  DialogView.swift
//  MixChat
//
//  Created by Михаил Фокин on 07.03.2023.
//

import UIKit

protocol DialogViewAction: AnyObject {
	func sendMessage(text: String?)
	func selectPhoto()
	func closeController()
}

final class DialogView: UIView {
	
	weak var delegate: DialogViewAction?
	
	private lazy var table: BaseTableView = {
		let table = BaseTableView(frame: .zero, style: .grouped)
		table.backgroundColor = .backgroundPrimary
		return table
	}()
	
	private lazy var navigationBar: BaseNavigationBar = {
		let navBar = BaseNavigationBar()
		navBar.backgroundColor = .topNavigation
		navBar.rightButton.isHidden = true
		navBar.delegate = self
		return navBar
	}()
	
	private lazy var bottomTableConstraint: NSLayoutConstraint = {
		return table.bottomAnchor.constraint(equalTo: self.bottomAnchor)
	}()
	
	private lazy var bottomTextFieadViewConstraint: NSLayoutConstraint = {
		return textFieldView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
	}()
	
	private lazy var textField: UITextField = {
		let textField = UITextField()
		textField.autocorrectionType = .no
		return textField
	}()
	
	private lazy var sendMessageButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "arrow.up.circle.fill")
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var selectPhotoButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "camera")
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(selectPhoto(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var subTextFieldView: UIView = {
		let subView = UIView()
		subView.layer.cornerRadius = 18
		subView.backgroundColor = .backgroundPrimary
		subView.layer.borderColor = UIColor.textSecondary.cgColor
		subView.layer.borderWidth = 1
		[textField, sendMessageButton].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			subView.addSubview($0)
		})
		
		NSLayoutConstraint.activate([
			textField.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
			textField.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 13),
			textField.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -8),
			
			sendMessageButton.heightAnchor.constraint(equalToConstant: 30),
			sendMessageButton.widthAnchor.constraint(equalToConstant: 30),
			sendMessageButton.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
			sendMessageButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -13)
		])
		return subView
	}()
	
	private lazy var textFieldView: UIView = {
		let view = UIView()
		
		[subTextFieldView, selectPhotoButton].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		})
		NSLayoutConstraint.activate([
			subTextFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
			subTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
			subTextFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
			
			selectPhotoButton.heightAnchor.constraint(equalToConstant: 22),
			selectPhotoButton.widthAnchor.constraint(equalToConstant: 25),
			selectPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
			selectPhotoButton.trailingAnchor.constraint(equalTo: subTextFieldView.leadingAnchor, constant: -12),
			selectPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		view.backgroundColor = .backgroundPrimary
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	private func setupView() {
		self.table.separatorStyle = .none
		self.backgroundColor = .backgroundPrimary
		[table, navigationBar, textFieldView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		})
		NSLayoutConstraint.activate([
			navigationBar.topAnchor.constraint(equalTo: super.topAnchor),
			navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			table.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			table.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
			table.bottomAnchor.constraint(equalTo: self.textFieldView.topAnchor),
			
			textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
			textFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
			textFieldView.heightAnchor.constraint(equalToConstant: 44),

			bottomTextFieadViewConstraint
		])
		textField.becomeFirstResponder()
	}
	
	func setNotification() {
		// Open & Close Keyboard Notifications
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	private func setTopConstrains(constraint: CGFloat?) {
		guard let constraint else { return }
		DispatchQueue.main.async {
			UIView.animate(
				withDuration: 0.8,
				delay: 0,
				usingSpringWithDamping: 0.8,
				initialSpringVelocity: 0,
				options: .curveEaseInOut,
				animations: {
					self.bottomTextFieadViewConstraint.constant = constraint
					self.layoutIfNeeded()
				}
			)
		}
	}

	func configure(with data: TableData?) {
		self.table.configure(with: data)
		self.table.scrollToBottomTable()
	}
	
	func setupNavigationBar(interlocutor: Interlocutor?) {
		self.navigationBar.userName.text = interlocutor?.name
		let manager = ImageManager()
		self.navigationBar.userImage.image = manager.creatingImageByInitials(userName: interlocutor?.name, size: 50)
		manager.loadImage(stringURL: interlocutor?.imageURL) { result in
			switch result {
			case.failure:
				break
			case .success(let image):
				self.navigationBar.userImage.image = image
			}
		}
	}
	
	func shakeTextFieldView() {
		shakeView(view: self.textFieldView)
	}
	
	private func shakeView(view: UIView?) {
		guard let view = view else { return }
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.07
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
		animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
		
		view.layer.add(animation, forKey: "position")
	}
	
	// - MARK: - Objc
	
	@objc
	func sendMessage(_ sender: UIButton) {
		self.delegate?.sendMessage(text: self.textField.text)
		self.textField.text = nil
	}
	
	@objc
	func selectPhoto(_ sender: UIButton) {
		self.delegate?.selectPhoto()
	}
	
	@objc
	private func keyboardWillShow(_ notification: Notification) {
		self.textFieldView.isHidden = false
		let userInfo = notification.userInfo
		guard let endFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
		setTopConstrains(constraint: -(endFrame.height + 1))
	}
	
	@objc
	private func keyboardWillHide() {
		self.textFieldView.isHidden = true
		setTopConstrains(constraint: -16)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(
			self,
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.removeObserver(
			self,
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
}

extension DialogView: BaseNavigationBarProtocol {
	
	func leftAction() {
		self.delegate?.closeController()
	}
}
