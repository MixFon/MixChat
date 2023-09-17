//
//  MessageCellModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import UIKit

private enum Constants {
	static let margin: CGFloat = 12
	static let radius: CGFloat = 18
	static let quarter: CGFloat = UIScreen.main.bounds.width / 6
	static let topBottom: CGFloat = 6
	static let widthTime: CGFloat = 35
	static let messageToTime: CGFloat = 4
	static let leftRightMargin: CGFloat = 20
}

protocol MessageCellProtocol: CellData {
	var time: String? { get }
	var type: MessageType? { get }
	var message: String? { get }
	var hasTail: Bool? { get set }
}

extension MessageCellProtocol {
	
	var height: CGFloat? { return calculateHeight(text: self.message ?? "") }
	
	var backgroundColor: UIColor? { return nil }
	
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
		guard let cell = cell as? MessageCell else { return }
		cell.configure(with: self)
	}
	
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifire)
		return tableView.dequeueReusableCell(withIdentifier: MessageCell.identifire, for: indexPath) as? MessageCell ?? .init()
	}
	
	private func calculateHeight(text: String) -> CGFloat {
		let leftMargin = Constants.leftRightMargin + Constants.quarter + Constants.margin
		let rightMargin = Constants.messageToTime + Constants.widthTime + Constants.margin + Constants.leftRightMargin
		let topMargin = Constants.margin + Constants.topBottom
		let bottomMargin = Constants.margin + Constants.topBottom
		let finalWidth = UIScreen.main.bounds.width - leftMargin - rightMargin
		let titleSize = height(text: text, width: finalWidth, font: UIFont.systemFont(ofSize: 17))
		return topMargin + titleSize + bottomMargin
	}
	
	private func height(text: String, width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = text.boundingRect(
			with: constraintRect,
			options: .usesLineFragmentOrigin,
			attributes: [NSAttributedString.Key.font: font],
			context: nil
		)
		return ceil(boundingBox.height)
	}
}

final class MessageCell: UITableViewCell, ConfigurableViewProtocol {
	
	private lazy var message: UILabel = {
		let lable = UILabel()
		lable.numberOfLines = -1
		lable.font = UIFont.systemFont(ofSize: 17)
		lable.textColor = .textPrimary
		return lable
	}()
	
	private lazy var time: UILabel = {
		let lable = UILabel()
		lable.font = UIFont.systemFont(ofSize: 11)
		lable.textColor = .textSecondary
		return lable
	}()
	
	private lazy var leftImageTail: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "LeftButtonTail")?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .bubbleSecondaty
		return imageView
	}()
	
	private lazy var rightImageTail: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "RightBubbleTail")?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .bubblePrimary
		return imageView
	}()
	
	private lazy var leadingOne: NSLayoutConstraint = {
		let leading = Constants.leftRightMargin + Constants.quarter
		return mainView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: leading)
	}()
	
	private lazy var tralingOne: NSLayoutConstraint = {
		return mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.leftRightMargin)
	}()
	
	private lazy var leadingTwo: NSLayoutConstraint = {
		return mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leftRightMargin)
	}()
	
	private lazy var tralingTwo: NSLayoutConstraint = {
		let trailing: CGFloat = Constants.quarter + Constants.leftRightMargin
		return mainView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -trailing)
	}()
	
	private lazy var mainView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = Constants.radius
		view.layer.masksToBounds = true
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		self.separatorInset = .zero
		self.backgroundColor = .backgroundPrimary
		contentView.backgroundColor = .clear
		
		[message, time, rightImageTail, leftImageTail].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			mainView.addSubview($0)
		})
		[rightImageTail, leftImageTail].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		})
		mainView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(mainView)
		
		NSLayoutConstraint.activate([
			time.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Constants.margin),
			time.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Constants.topBottom),
			time.widthAnchor.constraint(equalToConstant: Constants.widthTime),
			
			message.topAnchor.constraint(equalTo: mainView.topAnchor),
			message.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
			message.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.margin),
			message.trailingAnchor.constraint(equalTo: time.leadingAnchor, constant: -Constants.messageToTime),
			
			mainView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topBottom),
			mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.topBottom),
			
			rightImageTail.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4),
			rightImageTail.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 4),
			rightImageTail.heightAnchor.constraint(equalToConstant: 20),
			rightImageTail.widthAnchor.constraint(equalToConstant: 16),
			
			leftImageTail.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 4),
			leftImageTail.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 4),
			leftImageTail.heightAnchor.constraint(equalToConstant: 20),
			leftImageTail.widthAnchor.constraint(equalToConstant: 16)
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.leadingOne.isActive = false
		self.tralingOne.isActive = false
		self.leadingTwo.isActive = false
		self.tralingTwo.isActive = false
		self.layoutIfNeeded()
	}

	func configure(with data: MessageCellProtocol?) {
		self.time.text = data?.time
		self.message.text = data?.message
		UIView.animate(withDuration: 0.2) {
			switch data?.type {
			case .interlocutor:
				self.rightImageTail.isHidden = true
				self.leftImageTail.isHidden = data?.hasTail == false
				self.leadingTwo.isActive = true
				self.tralingTwo.isActive = true
				self.mainView.backgroundColor = UIColor.bubbleSecondaty
				self.message.textColor = .textPrimary
				self.time.textColor = .textSecondary
			case .user:
				self.rightImageTail.isHidden = data?.hasTail == false
				self.leftImageTail.isHidden = true
				self.leadingOne.isActive = true
				self.tralingOne.isActive = true
				self.mainView.backgroundColor = UIColor.bubblePrimary
				self.message.textColor = .white
				self.time.textColor = .white
			default:
				break
			}
			self.layoutIfNeeded()
		}
	}
}
