//
//  Logger.swift
//  MixChat
//
//  Created by Михаил Фокин on 21.02.2023.
//

import Foundation

final class Logger {
	
	let isLogging: Bool
	
	init(isLogging: Bool = true) {
		self.isLogging = isLogging
	}
	
	/// Функция, для логирования сообщения в консоль
	func log(_ message: String) {
#if DEBUG
		if self.isLogging {
			debugPrint(message)
		}
#endif
	}
}
