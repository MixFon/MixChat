//
//  ImagePickerCellModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 24.04.2023.
//

import UIKit

struct ImagePickerCellModel: ImagePickerCellProtocol {
	let small: String?
	let thumb: String?
	let onSelect: ((UIImage) -> Void)?
}
