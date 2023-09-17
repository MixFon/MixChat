//
//  Custom.swift
//  MixChat
//
//  Created by Михаил Фокин on 04.05.2023.
//

import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
	
	private let duration: TimeInterval
	
	init(duration: TimeInterval) {
		self.duration = duration
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		guard
			let fromViewController = transitionContext.viewController(forKey: .from) as? ProfileController, // 1
			let toViewController = transitionContext.viewController(forKey: .to) as? EditProfileController, // 2
			let fromView = fromViewController.view as? ProfileView
		else {
			return
		}
		
		let containerView = transitionContext.containerView
		let snapshotContentView = UIView()
		snapshotContentView.backgroundColor = .systemBlue
		snapshotContentView.frame = fromView.getFrameBoardView()
		snapshotContentView.layer.cornerRadius = 10
		
		containerView.addSubview(toViewController.view)
		containerView.addSubview(snapshotContentView)
		
		toViewController.view.isHidden = true
		
		let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
			snapshotContentView.frame = CGRect(
				x: UIScreen.main.bounds.maxX - 50,
				y: 40,
				width: 0,
				height: 0
			)
		}

		animator.addCompletion { position in
			toViewController.view.isHidden = false
			snapshotContentView.removeFromSuperview()
			transitionContext.completeTransition(position == .end)
		}

		animator.startAnimation()
	}
}
