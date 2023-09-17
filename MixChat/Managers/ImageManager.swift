//
//  ImageManager.swift
//  MixChat
//
//  Created by Михаил Фокин on 06.03.2023.
//

import UIKit

enum ImageManagerError: Error {
	case loadImage
}

final class ImageManager {
	
	private let cache = NSCache<NSString, UIImage>()
	private var task: Task<Void, Never>?
	
	/// Создание по первым буквам имени
	func creatingImageByInitials(userName: String?, size: CGFloat) -> UIImage? {
		let initials = getInitials(userName: userName)
		return imageFromInitials(initials: initials ?? "🙂", size: size)
	}
	
	/// Создание вертикального градиента
	private func makeGradientLayer() -> CAGradientLayer {
		let one = UIColor(red: 0xF1 / 0xff, green: 0x9F / 0xff, blue: 0xB4 / 0xff, alpha: 1).cgColor
		let two = UIColor(red: 0xEE / 0xff, green: 0x7B / 0xff, blue: 0x95 / 0xff, alpha: 1).cgColor
		let gradiertLayer = CAGradientLayer()
		gradiertLayer.colors = [one, two]
		gradiertLayer.startPoint = CGPoint(x: 0, y: 0)
		gradiertLayer.endPoint = CGPoint(x: 0, y: 1)
		return gradiertLayer
	}
	
	/// Создает строку по первым буквам
	private func getInitials(userName: String?) -> String? {
		guard let userName else { return nil }
		let firstLetters = userName.split(separator: " ").compactMap({ $0.first?.uppercased() })
		let firstTwoElem = Array(firstLetters.prefix(2))
		return firstTwoElem.reduce("", +)
	}
	
	/// Создание изображение по тексту
	private func imageFromInitials(initials: String, size: CGFloat) -> UIImage? {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
		label.backgroundColor = UIColor(red: 0xEE / 0xff, green: 0x7B / 0xff, blue: 0x95 / 0xff, alpha: 1)
		label.text = initials
		label.textColor = UIColor.white
		label.font = UIFont.boldSystemFont(ofSize: size / 2)
		label.textAlignment = .center

		// Создать изображение из метки
		UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		label.layer.render(in: context)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		
		return image
	}
	
	func taskCancel() {
		self.task?.cancel()
	}
	
	/// Произвдит загрузку изображений по url, возвращает результат на main потоке
	func loadImage(stringURL: String?, completion: @escaping (Result<UIImage, ImageManagerError>) -> Void) {
		guard let stringURL = stringURL else { return }
		if let cachedImage = self.cache.object(forKey: stringURL as NSString) {
			completion(.success(cachedImage))
		} else {
			self.task = Task {
				do {
					guard let url = URL(string: stringURL) else { return }
					let (data, _) = try await URLSession.shared.data(from: url)
					guard let image = UIImage(data: data) else { return }
					self.cache.setObject(image, forKey: stringURL as NSString)
					DispatchQueue.main.async {
						completion(.success(image))
					}
				} catch {
					DispatchQueue.main.async {
						completion(.failure(.loadImage))
					}
				}
			}
		}
	}
	
}
