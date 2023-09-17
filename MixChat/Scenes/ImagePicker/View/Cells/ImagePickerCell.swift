//
//  ImagePickerCell.swift
//  MixChat
//
//  Created by Михаил Фокин on 24.04.2023.
//

import UIKit

protocol ImagePickerCellProtocol {
	var small: String? { get }
	var thumb: String? { get }
	var onSelect: ((UIImage) -> Void)? { get }
}

final class ImagePickerCell: UICollectionViewCell, ConfigurableViewProtocol {
	
	private lazy var manager = ImageManager()
	private var onSelect: ((UIImage) -> Void)?
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		indicator.hidesWhenStopped = true
		return indicator
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupActions()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.activityIndicator.stopAnimating()
		self.imageView.image = nil
		self.manager.taskCancel()
	}
	
	private func setupActions() {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnCell))
		contentView.addGestureRecognizer(gesture)
	}
	
	private func setupUI() {
		[imageView, activityIndicator].forEach({
			contentView.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		})
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
	
	func configure(with data: ImagePickerCellProtocol?) {
		self.onSelect = data?.onSelect
		self.activityIndicator.startAnimating()
		self.imageView.image = UIImage(systemName: "photo")
		self.manager.loadImage(stringURL: data?.thumb) { [weak self] result in
			switch result {
			case .failure:
				break
			case .success(let image):
				self?.imageView.image = image
			}
			self?.activityIndicator.stopAnimating()
		}
	}
	
	@objc
	private func tapOnCell(sender: UITapGestureRecognizer) {
		if let image = imageView.image {
			self.onSelect?(image)
		}
	}
}
