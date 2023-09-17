//
//  ChoosePhotoManager.swift
//  MixChat
//
//  Created by Михаил Фокин on 03.05.2023.
//

import UIKit
import PhotosUI

protocol ChoosePhotoManagerProtocol {
	func choosePhoto()
}

protocol ChoosePhotoDelegate: AnyObject {
	func selectedImage(image: UIImage?)
}

/// Менеджер для выбора избражения, сделать фото, загрузить из фото, загрухить из интернета
final class ChoosePhotoManager: NSObject, ChoosePhotoManagerProtocol {
	
	private var controller: UIViewController?
	weak var delegate: ChoosePhotoDelegate?
	
	required init(controller: UIViewController?) {
		self.controller = controller
	}
	
	func choosePhoto() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let makePhotoOnCamera = UIAlertAction(title: "Сделать фото", style: .default) { _ in
			let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
			switch cameraAuthorizationStatus {
			case .notDetermined:
				self.requestCameraPermission()
			case .authorized:
				self.makePhoto()
			case .restricted, .denied:
				self.alertCameraAccessNeeded()
			@unknown default: return
			}
		}
		let selectPhoto = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
			self.selectPhoto()
		}
		let loadPhoto = UIAlertAction(title: "Загрузить", style: .default) { _ in
			self.loadPhoto()
		}
		let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
			
		}
		[makePhotoOnCamera, selectPhoto, loadPhoto, cancel].forEach({ alertController.addAction($0) })
		self.controller?.present(alertController, animated: true, completion: nil)
	}
	
	private func requestCameraPermission() {
		AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
			if accessGranted {
				self.makePhoto()
			}
		})
	}
	
	private func alertCameraAccessNeeded() {
		guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else { return }
		
		let alert = UIAlertController(
			title: "Необходим доступ к камере",
			message: "Для полноценного использования этого приложения необходим доступ к камере.",
			preferredStyle: .alert
		)
		let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		let settings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
			UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
		}
		alert.addAction(cancel)
		alert.addAction(settings)
		
		self.controller?.present(alert, animated: true, completion: nil)
	}
	
	private func makePhoto() {
		DispatchQueue.main.async {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = .camera
			imagePicker.allowsEditing = false
			self.controller?.present(imagePicker, animated: true)
		}
	}
	
	private func loadPhoto() {
		let configurator = ImagePickerConfigurator(pipe: self)
		let imagePickerController = configurator.configure()
		self.controller?.present(imagePickerController, animated: true)
	}
	
	private func selectPhoto() {
		var configuration = PHPickerConfiguration()
		configuration.filter = .images
		configuration.selectionLimit = 1
		configuration.preferredAssetRepresentationMode = .current
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		DispatchQueue.main.async {
			self.controller?.present(picker, animated: true)
		}
	}
}

extension ChoosePhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		if let pickedImage = info[.originalImage] as? UIImage {
			self.delegate?.selectedImage(image: pickedImage)
		}
		picker.dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
}

extension ChoosePhotoManager: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		if let result = results.first {
			if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
				result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
					if let image = image as? UIImage {
						DispatchQueue.main.async {
							self.delegate?.selectedImage(image: image)
						}
					}
				}
			}
		}
		picker.dismiss(animated: true)
	}
}

extension ChoosePhotoManager: ImagePickerPipe {
	
	func selectedImage(imageInfo: ImagePickerPipeModel?) {
		self.delegate?.selectedImage(image: imageInfo?.image)
	}
}
