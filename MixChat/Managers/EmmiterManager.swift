//
//  EmmiterManager.swift
//  MixChat
//
//  Created by Михаил Фокин on 03.05.2023.
//

import UIKit

final class EmitterManager: NSObject {
	
	private let cell = CAEmitterCell()
	private let emitter = CAEmitterLayer()
	private let superView: UIView
	
	required init(superView: UIView) {
		self.superView = superView
		super.init()
		setupEmitter()
	}
	
	private func setupEmitter() {
		
		let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		self.superView.addGestureRecognizer(panRecognizer)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		self.superView.addGestureRecognizer(tapRecognizer)
		
		// Создаем эмиттер частиц
		emitter.emitterPosition = CGPoint(x: self.superView.bounds.width / 2, y: self.superView.bounds.height / 2)
		emitter.emitterSize = CGSize(width: 50, height: 50)
		emitter.emitterShape = .circle
		
		cell.contents = UIImage(named: "MixChat")?.cgImage
		cell.birthRate = 10
		cell.lifetime = 0.0
		cell.velocity = 100
		cell.spin = -0.5
		cell.velocityRange = 50
		cell.emissionRange = .pi * 2
		
		emitter.emitterCells = [cell]
		superView.subviews.forEach({
			$0.layer.addSublayer(emitter)
		})
		superView.layer.addSublayer(emitter)
	}
	
	func setEmitter(view: UIView) {
		view.layer.addSublayer(emitter)
	}

	private func start() {
		emitter.birthRate = 1
		cell.lifetime = 1
	}
	
	private func stop() {
		emitter.birthRate = 0
		cell.lifetime = 0
	}
	
	@objc
	private func handlePan(_ sender: UIPanGestureRecognizer) {
		let location = sender.location(in: self.superView)
		emitter.emitterPosition = location
		switch sender.state {
		case .began:
			start()
			print(1)
		case .ended:
			stop()
			print(2)
		default:
			break
		}
	}
	
	@objc
	private func handleTap(_ sender: UILongPressGestureRecognizer) {
		let location = sender.location(in: self.superView)
		emitter.emitterPosition = location
		switch sender.state {
		case.began:
			start()
			print(3)
		case .ended:
			stop()
			print(4)
		default:
			break
		}
	
	}
}
