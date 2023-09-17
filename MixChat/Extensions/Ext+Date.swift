//
//  Ext+Date.swift
//  MixChat
//
//  Created by Михаил Фокин on 08.03.2023.
//

import Foundation

extension Date {
	
	func timeAgoDisplay() -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		return formatter.localizedString(for: self, relativeTo: Date())
	}
	
	func day() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd"
		return formatter.string(from: self)
	}
	
	func month() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "mmmm"
		return formatter.string(from: self)
	}

	func year() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy"
		return formatter.string(from: self)
	}
	
	/// Возвращает строку формата dd-MM-yyyy
	func dayMonthYear() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy"
		return formatter.string(from: self)
		
	}
}
