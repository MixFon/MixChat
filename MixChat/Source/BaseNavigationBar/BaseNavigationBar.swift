//
//  BaseNavigationBar.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import UIKit

private enum Constants {
	static let margin: CGFloat = 18
	static let imageSize: CGFloat = 50
	static let leftButtonSize: CGFloat = 20
	static let rightButtonSize: CGFloat = 20
	static let marginNameImage: CGFloat = 5
}

protocol BaseNavigationBarProtocol: AnyObject {
	func leftAction()
	func rightAction()
}

extension BaseNavigationBarProtocol {
	func leftAction() {}
	func rightAction() {}
}

class BaseNavigationBar: UIView {
	
	weak var delegate: BaseNavigationBarProtocol?
	
	lazy var contentView: UIView = {
		let view = UIView()
		return view
	}()
	
	lazy var rightButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
		button.addTarget(self, action: #selector(pressRightButton), for: .touchUpInside)
		return button
	}()
	
	@objc
	private func pressRightButton() {
		self.delegate?.rightAction()
	}
	
	lazy var leftButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
		button.addTarget(self, action: #selector(pressLeftButton), for: .touchUpInside)
		return button
	}()
	
	@objc
	private func pressLeftButton() {
		self.delegate?.leftAction()
	}
	
	lazy var userImage: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.imageSize, height: Constants.imageSize))
		imageView.layer.cornerRadius = Constants.imageSize / 2
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	lazy var userName: UILabel = {
		let lable = UILabel()
		lable.textColor = .textPrimary
		lable.font = UIFont.systemFont(ofSize: 11)
		lable.textAlignment = .center
		return lable
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
		
		[contentView, rightButton, leftButton, userImage, userName].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview($0)
		})
		self.backgroundColor = .green
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
			leftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			leftButton.heightAnchor.constraint(equalToConstant: 30),
			leftButton.widthAnchor.constraint(equalToConstant: 20),
			
			rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
			rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			rightButton.heightAnchor.constraint(equalToConstant: Constants.rightButtonSize),
			rightButton.widthAnchor.constraint(equalToConstant: Constants.rightButtonSize),
			
			userImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			userImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			userImage.heightAnchor.constraint(equalToConstant: Constants.imageSize),
			userImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),
			
			userName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			userName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
			userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
			userName.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 5),
			
			self.bottomAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10)
			
		])
	}

}
