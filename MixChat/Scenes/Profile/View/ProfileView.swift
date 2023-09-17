//
//  ProfileView.swift
//  MixChat
//
//  Created by Михаил Фокин on 18.04.2023.
//

import UIKit

protocol ProfileViewAction: AnyObject {
	func pressEdit()
	func pressAddPhoto()
}

protocol ProfileShow {
	var title: String? { get }
	var userProfile: UserProfileProtocol? { get }
}

final class ProfileView: UIView {
	
	@IBOutlet private weak var userBio: UILabel!
	@IBOutlet private weak var userName: UILabel!
	@IBOutlet private weak var userPhoto: UIImageView!
	@IBOutlet private weak var addPhotoButton: UIButton!
	
	@IBOutlet private weak var editButton: UIButton!
	@IBOutlet private weak var boardView: UIView!
	
	private var navigationBar: UINavigationBar!
	private var navigationItem: UINavigationItem!
	
	private var emitterManager: EmitterManager?
	private var startTransform: CGAffineTransform?
	
	weak var delegate: ProfileViewAction?
	
	private var onPressRightButton: (() -> Void)?
	
	private var isAnimation = false
	
	@IBAction func pressAddPhoto(_ sender: UIButton) {
		self.delegate?.pressAddPhoto()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.emitterManager = EmitterManager(superView: self)
		self.backgroundColor = .backgroundPrimary
		setupUI()
	}
	
	private func setupUI() {
		self.backgroundColor = .backgroundSecondary
		self.userPhoto.layer.cornerRadius = 150 / 2
		
		setupEditButton()
		
		self.boardView.backgroundColor = .backgroundPrimary
		self.boardView.clipsToBounds = true
		self.boardView.layer.cornerRadius = 10
	}
	
	func getFrameBoardView() -> CGRect {
		return self.editButton.frame
	}
	
	func setupNavigationItem(navigationItem: UINavigationItem?) {
		self.navigationItem = navigationItem
	}
	
	func setupNavigationBar(navigationBar: UINavigationBar?) {
		self.navigationBar = navigationBar
		navigationBar?.shadowImage = UIImage()
		navigationBar?.backgroundColor = .backgroundSecondary
		navigationBar?.prefersLargeTitles = true
	}
	
	func configure(with data: ProfileShow?) {
		UIView.animate(withDuration: 0.3) {
			self.navigationItem.title = data?.title
			self.setupLables(data: data)
			if let userPhoto = data?.userProfile?.userPhoto {
				self.userPhoto.image = userPhoto
			} else {
				let imageManager = ImageManager()
				self.userPhoto.image = imageManager.creatingImageByInitials(userName: data?.userProfile?.userName, size: 150)
			}
			self.layoutIfNeeded()
		}
	}
	
	private func setupEditButton() {
		self.editButton.setTitle("Edit Profile", for: .normal)
		self.editButton.tintColor = .backgroundPrimary
		self.editButton.backgroundColor = .systemBlue
		self.editButton.layer.cornerRadius = 14
		
		self.editButton.addTarget(self, action: #selector(pressEdit), for: .touchUpInside)
		
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressEdit))
		self.editButton.addGestureRecognizer(longPressGesture)
	}
	
	private func setupLables(data: ProfileShow?) {
		self.userBio.text = data?.userProfile?.userBio
		self.userName.text = data?.userProfile?.userName
	}
	
	private func startAnimations() {
		// задаем длительность анимации
		let duration = 0.3

		// задаем параметры анимации
		let rotationAngle: CGFloat = 18.0 * .pi / 180.0
		let translationDistance: CGFloat = 5.0

		// определяем анимацию
		let rotateClockwise = CGAffineTransform(rotationAngle: rotationAngle)
		let rotateCounterClockwise = CGAffineTransform(rotationAngle: -rotationAngle)
		let translateUp = CGAffineTransform(translationX: 0.0, y: -translationDistance)
		let translateDown = CGAffineTransform(translationX: 0.0, y: translationDistance)
		let translateLeft = CGAffineTransform(translationX: -translationDistance, y: 0.0)
		let translateRight = CGAffineTransform(translationX: translationDistance, y: 0.0)
		self.startTransform = self.editButton.transform
		UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [.repeat, .allowUserInteraction], animations: {
			
			// Анимация 1
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
				self.editButton.transform = rotateClockwise
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
				self.editButton.transform = translateUp.concatenating(translateLeft)
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
				self.editButton.transform = rotateCounterClockwise
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
				self.editButton.transform = translateDown.concatenating(translateRight)
			})
		})
	}
	
	func stopAnimations() {
		self.isAnimation = false
		UIView.animate(withDuration: 0.3) {
			if let startTransform = self.startTransform {
				self.editButton.transform = startTransform
			}
		} completion: { _ in
			self.startTransform = nil
		}
	}
	
	// - MARK: - obc
	
	@objc
	private func longPressEdit(_ sender: UILongPressGestureRecognizer) {
		switch sender.state {
		case .began:
			print("Long Press")
			self.isAnimation = !self.isAnimation
			if self.isAnimation {
				startAnimations()
			} else {
				stopAnimations()
			}
		default:
			break
		}
	}
	
	@objc
	private func pressEdit(_ sender: AnyObject) {
		self.delegate?.pressEdit()
	}
}
