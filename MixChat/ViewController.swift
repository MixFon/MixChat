//
//  ViewController.swift
//  MixChat
//
//  Created by Михаил Фокин on 19.02.2023.
//

import UIKit

final class ViewController: UIViewController {
	
	private let logger = Logger()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// Когда экран вот-вот появляется, вызывается метод viewWillAppear().
	// Этот метод используется для обновления данных, которые могут измениться, когда пользователь переходит на другой экран или
	// возвращается на этот экран. Например, вы можете использовать его, чтобы обновить таблицу данных или сделать запрос к API.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.logger.log("Called method: \(#function)")
	}
	
	// Перед вызовом layoutSubviews вызывается метод viewWillLayoutSubviews().
	// Этот метод вызывается каждый раз, когда размер view изменяется.
	// Используйте его для обновления границ и расположения элементов пользовательского интерфейса.
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.logger.log("Called method: \(#function)")
	}
	
	// func layoutSubviews() {}
	
	// После вызова layoutSubviews вызывается метод viewDidLayoutSubviews()
	// Этот метод вызывается после того, как view была размещена на экране и обновлена ее разметка.
	// Используйте его для изменения элементов пользовательского интерфейса, которые зависят от размера view.
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.logger.log("Called method: \(#function)")
	}
	
	// Вызывается, когда экран был полностью представлен.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.logger.log("Called method: \(#function)")
	}
	
	// Когда view перестает отображаться, вызывается метод viewWillDisappear().
	// Используйте его для сохранения данных, которые могут измениться при переходе на другой экран.
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.logger.log("Called method: \(#function)")
	}
	
	// Затем вызывается метод viewDidDisappear(), который вызывается после того, как view полностью исчезла.
	// Этот метод используется для очистки ресурсов, которые больше не нужны, например, для удаления объектов из памяти.
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.logger.log("Called method: \(#function)")
	}

	@IBAction func pressStart(_ sender: Any) {
		let controller = ProfileController()
		present(controller, animated: true)
	}
}
