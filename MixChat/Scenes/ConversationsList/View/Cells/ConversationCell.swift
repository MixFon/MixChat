//
//  ConversationCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import UIKit

protocol ConfigurableViewProtocol {
	associatedtype CellModelProtocol
	func configure(with data: CellModelProtocol?)
}

protocol ConversationCellProtocol: CellData, ConversationsDialogProtocol {
	var date: String? { get }
	var isNotMessage: Bool? { get }
	var onSelect: (() -> Void)? { get }
	var onSwipedLeft: (() -> Void)? { get }
}

private enum Constants {
	static let margin: CGFloat = 16
	static let borderWidth: CGFloat = 2
	static let indicatorSize: CGFloat = 15
	static let imageUserSize: CGFloat = 50
	static let imageChevronSize: CGFloat = 16
}

extension ConversationCellProtocol {
	
	var height: CGFloat? { return 86 }
	
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
		guard let cell = cell as? ConversationCell else { return }
		cell.configure(with: self)
	}
	
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifire)
		return tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifire, for: indexPath) as? ConversationCell ?? .init()
	}
}

final class ConversationCell: UITableViewCell, ConfigurableViewProtocol {
	
	private lazy var manager = ImageManager()
	
	private var onSelect: (() -> Void)?
	private var onSwipedLeft: (() -> Void)?
	
	private lazy var name: UILabel = {
		let name = UILabel()
		name.font = UIFont.boldSystemFont(ofSize: 17)
		name.textAlignment = .left
		name.textColor = .textPrimary
		return name
	}()
	
	private lazy var lastMessage: UILabel = {
		let message = UILabel()
		message.font = UIFont.boldSystemFont(ofSize: 15)
		message.textAlignment = .left
		message.textColor = .textSecondary
		message.numberOfLines = 2
		return message
	}()
	
	private lazy var lastMessageImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 4
		imageView.isHidden = true
		return imageView
	}()
	
	private lazy var dateMessage: UILabel = {
		let date = UILabel()
		date.font = UIFont.systemFont(ofSize: 15)
		date.textAlignment = .right
		date.textColor = .textSecondary
		return date
	}()
	
	private lazy var userImage: UIImageView = {
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.imageUserSize, height: Constants.imageUserSize))
		imageView.layer.cornerRadius = Constants.imageUserSize / 2
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.addSubview(self.indicator)
		imageView.backgroundColor = .backgroundPrimary
	
		return imageView
	}()
	
	private lazy var imageChevron: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.image = UIImage(systemName: "chevron.right")
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .textSecondary
		return imageView
	}()
    
    private lazy var deleteImage: UIImageView = {
        let imageTrash = UIImageView(image: UIImage(systemName: "trash"))
        imageTrash.backgroundColor = .systemRed
        imageTrash.tintColor = .textPrimary
        imageTrash.contentMode = .scaleAspectFit
        return imageTrash
    }()
    
    private lazy var deleteImageRightConstraint: NSLayoutConstraint = {
        return deleteImage.leadingAnchor.constraint(equalTo: trailingAnchor)
    }()
    
    private lazy var deleteImageLeftConstraint: NSLayoutConstraint = {
        return deleteImage.leadingAnchor.constraint(equalTo: leadingAnchor)
    }()
	
	private lazy var indicator: UIView = {
		let view = UIView()
		let borderWidth: CGFloat = 2
		let circleCize = Constants.indicatorSize - borderWidth * 2
		let greenCircle = UIView()
		greenCircle.backgroundColor = .backgroundGreen
		greenCircle.layer.cornerRadius = circleCize / 2
		greenCircle.layer.masksToBounds = true
		greenCircle.translatesAutoresizingMaskIntoConstraints = false
		
		view.layer.cornerRadius = Constants.indicatorSize / 2
		view.layer.masksToBounds = true
		view.backgroundColor = .backgroundPrimary
		
		view.addSubview(greenCircle)
		greenCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		greenCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		greenCircle.heightAnchor.constraint(equalToConstant: circleCize).isActive = true
		greenCircle.widthAnchor.constraint(equalToConstant: circleCize).isActive = true
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		[
			self.name,
			self.lastMessage,
			self.lastMessageImage,
			self.dateMessage,
			self.userImage,
			self.imageChevron,
			self.indicator,
            self.deleteImage
		].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.contentView.addSubview($0)
		})
		self.backgroundColor = .backgroundPrimary
		NSLayoutConstraint.activate([
			self.userImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.margin),
			self.userImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			self.userImage.widthAnchor.constraint(equalToConstant: Constants.imageUserSize),
			self.userImage.heightAnchor.constraint(equalToConstant: Constants.imageUserSize),
			
			self.lastMessage.leadingAnchor.constraint(equalTo: self.userImage.trailingAnchor, constant: 12),
			self.lastMessage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.margin),
			self.lastMessage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Constants.margin),
			
			self.lastMessageImage.topAnchor.constraint(equalTo: self.lastMessage.topAnchor, constant: 4),
			self.lastMessageImage.leadingAnchor.constraint(equalTo: self.lastMessage.leadingAnchor),
			self.lastMessageImage.trailingAnchor.constraint(equalTo: self.lastMessage.trailingAnchor),
			self.lastMessageImage.bottomAnchor.constraint(equalTo: self.lastMessage.bottomAnchor, constant: 10),
			
			self.name.leadingAnchor.constraint(equalTo: self.lastMessage.leadingAnchor),
			self.name.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.margin),
			self.name.bottomAnchor.constraint(equalTo: self.lastMessage.topAnchor),
			
			self.dateMessage.leadingAnchor.constraint(greaterThanOrEqualTo: self.name.trailingAnchor, constant: 10),
			self.dateMessage.trailingAnchor.constraint(equalTo: self.imageChevron.leadingAnchor),
			self.dateMessage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.margin),
			self.dateMessage.bottomAnchor.constraint(equalTo: self.lastMessage.topAnchor),
			self.dateMessage.widthAnchor.constraint(greaterThanOrEqualToConstant: 55),
			
			self.imageChevron.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.margin),
			self.imageChevron.bottomAnchor.constraint(equalTo: self.lastMessage.topAnchor),
			self.imageChevron.heightAnchor.constraint(equalToConstant: Constants.imageChevronSize),
			self.imageChevron.widthAnchor.constraint(equalToConstant: Constants.imageChevronSize),
			self.imageChevron.trailingAnchor.constraint(equalTo: self.lastMessage.trailingAnchor),
			
			self.indicator.trailingAnchor.constraint(equalTo: userImage.trailingAnchor),
			self.indicator.topAnchor.constraint(equalTo: userImage.topAnchor),
			self.indicator.widthAnchor.constraint(equalToConstant: Constants.indicatorSize),
            self.indicator.heightAnchor.constraint(equalToConstant: Constants.indicatorSize),
            
            self.deleteImageRightConstraint,
            self.deleteImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.deleteImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.deleteImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
		
		let gesturePress = UITapGestureRecognizer(target: self, action: #selector(self.selectCell))
		self.addGestureRecognizer(gesturePress)
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
		swipeLeft.direction = .left
		self.addGestureRecognizer(swipeLeft)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.manager.taskCancel()
		self.userImage.image = nil
		self.lastMessage.text = nil
		self.lastMessageImage.image = nil
		self.lastMessageImage.isHidden = true
		self.name.text = nil
		self.dateMessage.text = nil
        self.deleteImageLeftConstraint.isActive = false
        self.deleteImageRightConstraint.isActive = true
	}
	
	func configure(with data: ConversationCellProtocol?) {
		self.userImage.image = self.manager.creatingImageByInitials(userName: data?.name, size: 45)
		setImageToUserImage(stringURL: data?.imageURL)
        self.onSwipedLeft = data?.onSwipedLeft
		self.lastMessageImage.isHidden = true
		if let message = data?.message, verifyUrl(urlString: message) {
			setImageToLastMessageImage(stringURL: message)
		}
		self.lastMessage.text = data?.message
		self.name.text = data?.name
		self.dateMessage.text = data?.date
		self.onSelect = data?.onSelect
		if data?.isOnline == true {
			self.indicator.isHidden = false
		} else {
			self.indicator.isHidden = true
		}
		if data?.hasUnreadMessages == true {
			self.lastMessage.font = UIFont.boldSystemFont(ofSize: 15)
			self.lastMessage.textColor = .textPrimary
		} else {
			self.lastMessage.font = UIFont.systemFont(ofSize: 15)
			self.lastMessage.textColor = .textSecondary
		}
		
		self.dateMessage.isHidden = data?.isNotMessage == true
		self.imageChevron.isHidden = data?.isNotMessage == true
	}
	
	private func verifyUrl(urlString: String?) -> Bool {
		guard let urlString = urlString,
			  let url = URL(string: urlString) else {
			return false
		}
		return UIApplication.shared.canOpenURL(url)
	}
	
	private func setImageToUserImage(stringURL: String?) {
		self.manager.loadImage(stringURL: stringURL) { [weak self] result in
			switch result {
			case .failure:
				break
			case .success(let image):
				self?.userImage.image = image
			}
		}
	}
	
	private func setImageToLastMessageImage(stringURL: String?) {
		self.manager.loadImage(stringURL: stringURL) { [weak self] result in
			switch result {
			case .failure:
				break
			case .success(let image):
				self?.lastMessageImage.image = image
				self?.lastMessageImage.isHidden = false
			}
		}
	}
	
	// - MARK: - obj
	
	@objc
    private func selectCell(sender: UITapGestureRecognizer) {
		self.onSelect?()
	}
	
	@objc
	func swipedLeft() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut]) {
            self.deleteImageRightConstraint.isActive = false
            self.deleteImageLeftConstraint.isActive = true
            self.layoutIfNeeded()
		} completion: { bl in
            self.onSwipedLeft?()
            print("swipe", bl)
		}
	}
	 
}
