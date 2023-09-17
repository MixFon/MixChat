//
//  ImagePickerInteractor.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

protocol ImagePickerBusinessLogic: AnyObject {
	func makeState(requst: ImagePickerModel.Request)
}

protocol ImagePickerDataStore {

}

final class ImagePickerInteractor: ImagePickerBusinessLogic {
    
    private var presenter: ImagePickerPresentationLogic?
    
    init(presenter: ImagePickerPresentationLogic?) {
        self.presenter = presenter
    }
	
	func makeState(requst: ImagePickerModel.Request) {
		switch requst {
		case .start:
			fetchRandomImages()
		}
	}
	
	private func fetchRandomImages() {
		Task {
			do {
				let network = UnsplashService(host: "api.unsplash.com")
				async let one = network.fetchRandomImage()
				async let two = network.fetchRandomImage()
				async let three = network.fetchRandomImage()
				async let four = network.fetchRandomImage()
				
				let datas = try await [one, two, three, four]
				let allModels = datas.flatMap({ $0 })
				self.presenter?.buildState(response: .start(allModels))
			} catch NetworkError.parsingJSON(let data) {
				let dataMessage = String(data: data, encoding: .utf8)
				self.presenter?.buildState(response: .showError(dataMessage))
			} catch {
				self.presenter?.buildState(response: .showError(error.localizedDescription))
			}
		}
	}
    
}

extension ImagePickerInteractor: ImagePickerDataStore {

}
