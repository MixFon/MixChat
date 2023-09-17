//
//  ImagePickerView.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

import UIKit

protocol ImagePickerAction: AnyObject {
	func pressCancel()
}

protocol ImagePickerShow {
	var cells: [ImagePickerCellProtocol]? { get }
}

final class ImagePickerView: UIView {
	
	weak var delegate: ImagePickerAction?
	
	private var navigationItem: UINavigationItem?
	
	private var cells: [ImagePickerCellProtocol] = [] {
		didSet {
			self.collectionView.reloadData()
		}
	}
	
	private lazy var navigationBar: UINavigationBar = {
		let navigationBar = UINavigationBar(frame: .zero)
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.backgroundColor = .backgroundPrimary
		let navItem = UINavigationItem(title: "Select photo")
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pressCancel))
		navItem.leftBarButtonItem = cancelButton
		navigationBar.setItems([navItem], animated: false)
		return navigationBar
	}()
	
	private lazy var collectionView: UICollectionView = {
		let layout = createLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(ImagePickerCell.self, forCellWithReuseIdentifier: ImagePickerCell.identifire)
		collectionView.backgroundColor = .backgroundPrimary
		return collectionView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	func configure(with data: ImagePickerShow?) {
		if let cells = data?.cells {
			self.cells = cells
		}
	}
	
	private func createLayout() -> UICollectionViewCompositionalLayout {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalWidth(1.0 / 3.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.75, bottom: 0, trailing: 0.75)

		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) // отступы контента внутри секции

		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
	
	private func setupView() {
		self.backgroundColor = .backgroundPrimary
		[navigationBar, collectionView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		})
		NSLayoutConstraint.activate([
			navigationBar.topAnchor.constraint(equalTo: super.topAnchor),
			navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	// MARK: - obj
	
	@objc
	private func pressCancel() {
		self.delegate?.pressCancel()
	}
}

extension ImagePickerView: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.cells.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.identifire, for: indexPath) as? ImagePickerCell
		else { return .init() }
		let service = self.cells[indexPath.row]
		cell.configure(with: service)
		return cell
	}
}
