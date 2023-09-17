//
//  ImagePickerModels.swift
//  MixChat
//
//  Created by Михаил Фокин on 22.04.2023.
//

import UIKit

enum ImagePickerModel {
	
    enum Request {
		case start
    }
    
    enum Response {
		case start([UnsplashModel]?)
		case showError(String?)
    }
    
    enum ViewModel {
		case display(Show?)
		case showError(String?)
		case selectImage(ImagePickerPipeModel?)
		
		struct Show: ImagePickerShow {
			let cells: [ImagePickerCellProtocol]?
		}
    }
}
