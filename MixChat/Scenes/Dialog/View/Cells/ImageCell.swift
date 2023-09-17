//
//  ImageCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 27.04.2023.
//

import UIKit

protocol ImageCellProtocol: CellData {
	var time: String? { get }
	var type: MessageType? { get }
	var imageUrl: String? { get }
}

extension ImageCellProtocol {
	
	var height: CGFloat? { return 170 }
	
	func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
		guard let cell = cell as? ImageCell else { return }
		cell.configure(with: self)
	}
	
	func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.identifire)
		return tableView.dequeueReusableCell(withIdentifier: ImageCell.identifire, for: indexPath) as? ImageCell ?? .init()
	}
}

final class ImageCell: UITableViewCell, ConfigurableViewProtocol {
	
	private lazy var manager = ImageManager()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		indicator.hidesWhenStopped = true
		return indicator
	}()
	
	private lazy var photo: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 18
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var time: UILabel = {
		let lable = UILabel()
		lable.font = UIFont.systemFont(ofSize: 11)
		lable.textColor = .textSecondary
		return lable
	}()
	
	private lazy var leadingImage: NSLayoutConstraint = {
		return self.photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
	}()
	
	private lazy var tralingImage: NSLayoutConstraint = {
		return self.photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageView?.image = nil
		self.leadingImage.isActive = false
		self.tralingImage.isActive = false
		self.activityIndicator.stopAnimating()
	}
	
	private func setupUI() {
		self.selectionStyle = .none
		contentView.backgroundColor = .clear
		[photo, time, activityIndicator].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		})
		NSLayoutConstraint.activate([
			photo.widthAnchor.constraint(equalToConstant: 150),
			photo.heightAnchor.constraint(equalToConstant: 150),
			
			time.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 4),
			time.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			time.topAnchor.constraint(equalTo: photo.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: photo.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: photo.centerYAnchor)
		])
	}

	func configure(with data: ImageCellProtocol?) {
		self.time.text = data?.time
		self.activityIndicator.startAnimating()
		self.photo.image = UIImage(systemName: "photo")
		self.manager.loadImage(stringURL: data?.imageUrl) { [weak self] result in
			switch result {
			case .failure:
				break
			case .success(let image):
				self?.photo.image = image
			}
			self?.activityIndicator.stopAnimating()
		}
		UIView.animate(withDuration: 0.2) {
			switch data?.type {
			case .interlocutor:
				self.leadingImage.isActive = true
				self.tralingImage.isActive = false
			case .user:
				self.leadingImage.isActive = false
				self.tralingImage.isActive = true
			default:
				break
			}
			self.layoutIfNeeded()
		}
	}
}
