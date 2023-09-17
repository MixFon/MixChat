//
//  Ext+String.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.04.2023.
//

import Foundation

extension String {
	
	static func getRandomString(lenth: Int) -> String {
		let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		var randomString = ""
		for _ in 1...lenth {
			if let char = alphabet.randomElement() {
				randomString.append(char)
			}
		}
		return randomString
	}
}
