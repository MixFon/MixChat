//
//  ImagePickerPresenter.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

protocol ImagePickerPresentationLogic: AnyObject {
	func buildState(response: ImagePickerModel.Response)
}

final class ImagePickerPresenter: ImagePickerPresentationLogic {
    
	private weak var controller: ImagePickerDisplayLogic?
    
    init(controller: ImagePickerDisplayLogic?) {
        self.controller = controller
    }
    
	func buildState(response: ImagePickerModel.Response) {
		switch response {
		case .start(let models):
			let cells = prepareModels(models: models)
			let show = ImagePickerModel.ViewModel.Show(cells: cells)
			self.controller?.displayContent(show: .display(show))
		case .showError(let errorMessage):
			self.controller?.displayContent(show: .showError(errorMessage))
		}
	}
	
	private func prepareModels(models: [UnsplashModel]?) -> [ImagePickerCellProtocol]? {
		return models?.compactMap({ elem in
			let model = ImagePickerCellModel(
				small: elem.urls?.small,
				thumb: elem.urls?.thumb,
				onSelect: { [weak self] image in
					let imagePickerPipeModel = ImagePickerPipeModel(
						image: image,
						imageURL: elem.urls?.thumb
					)
					self?.controller?.displayContent(show: .selectImage(imagePickerPipeModel))
				}
			)
			return model
		})
		
	}
}
