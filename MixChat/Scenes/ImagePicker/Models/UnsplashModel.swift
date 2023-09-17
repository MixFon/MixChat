//
//  UnsplashModel.swift
//  MixChat
//
//  Created by Михаил Фокин on 23.04.2023.
//

import Foundation

struct UnsplashModel: Codable {
	let urls: Urls?
}

struct Urls: Codable {
	let raw: String?
	let full: String?
	let small: String?
	let thumb: String?
	let regular: String?
}
