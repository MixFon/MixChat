//
//  ThemeViewController.swift
//  MixChat
//
//  Created by Михаил Фокин on 10.03.2023.
//

import UIKit

final class ThemeViewController: UIViewController {
	
	/*
	 В данный момен утечки памяти нет, так как делегатом назначаю ThemeManager в методе
	 presentThemeViewController.
	
	 Утечка памяти могла бы возникать, если бы мы объявили поле с типом ThemeViewController в
	 классе ConversationsListRouter и назначили бы этот класс (ConversationsListRouter) делегатом
	 для ThemeViewController, так как ConversationsListRouter держал бы сильную ссылку на
	 ThemeViewController, а ThemeViewController деражал сильную ссылку на ConversationsListRouter.
	 Чтобы избежать утечки нужно было бы объявить var themeDelegate со слабой ссылкой:
	 
	 weak var themeDelegate: ThemesPickerDelegate?
	 */
	private var themeDelegate: ThemesPickerDelegate?
	private var emitterManager: EmitterManager?
	
	let imageCircle = UIImage(systemName: "circle")
	let imageCheckmark = UIImage(systemName: "checkmark.circle.fill")
	
	init(themeDelegate: ThemesPickerDelegate? = nil) {
		super.init(nibName: nil, bundle: nil)
		self.themeDelegate = themeDelegate

		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .backgroundPrimary
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var dayImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "DayImage")
		return imageView
	}()
	
	private lazy var nightImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "NightImage")
		return imageView
	}()
	
	private lazy var checkDayImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = self.imageCheckmark
		return imageView
	}()
	
	private lazy var checkNightImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = self.imageCircle
		return imageView
	}()
	
	private lazy var dayView: UIView = {
		let view = UIView()
		let lable = UILabel()
		lable.text = "Day"
		view.backgroundColor = .backgroundPrimary
		[lable, checkDayImageView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		})
		NSLayoutConstraint.activate([
			lable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			lable.topAnchor.constraint(equalTo: view.topAnchor),
			lable.bottomAnchor.constraint(equalTo: checkDayImageView.topAnchor, constant: -10),
			checkDayImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		let gesturePress = UITapGestureRecognizer(target: self, action: #selector(self.pressOnDayView))
		view.addGestureRecognizer(gesturePress)
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Settings"
	}
	
	@objc
	func pressOnDayView(sender: UITapGestureRecognizer) {
		selectDay()
		self.themeDelegate?.updateStyle(style: .light)
	}
	
	private func selectDay() {
		self.checkDayImageView.image = self.imageCheckmark
		self.checkNightImageView.image = self.imageCircle
	}
	
	private lazy var nightView: UIView = {
		let view = UIView()
		let lable = UILabel()
		lable.text = "Night"
		view.backgroundColor = .backgroundPrimary
		[lable, checkNightImageView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		})
		NSLayoutConstraint.activate([
			lable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			lable.topAnchor.constraint(equalTo: view.topAnchor),
			lable.bottomAnchor.constraint(equalTo: checkNightImageView.topAnchor, constant: -10),
			checkNightImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		let gesturePress = UITapGestureRecognizer(target: self, action: #selector(self.pressOnNightView))
		view.addGestureRecognizer(gesturePress)
		return view
	}()
	
	@objc
	func pressOnNightView(sender: UITapGestureRecognizer) {
		selectNight()
		self.themeDelegate?.updateStyle(style: .dark)
	}
	
	private func selectNight() {
		self.checkDayImageView.image = self.imageCircle
		self.checkNightImageView.image = self.imageCheckmark
	}
	
	private func setupView() {
		self.view.backgroundColor = .backgroundSecondary
		[dayView, nightView, dayImageView, nightImageView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			backgroundView.addSubview($0)
		})
		
		[backgroundView].forEach({
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		})
		
		NSLayoutConstraint.activate([
			backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			backgroundView.heightAnchor.constraint(equalToConstant: 170),
			
			dayImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
			dayImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 50),
			dayImageView.widthAnchor.constraint(equalToConstant: 80),
			dayImageView.heightAnchor.constraint(equalToConstant: 55),
			
			dayView.centerXAnchor.constraint(equalTo: dayImageView.centerXAnchor),
			dayView.topAnchor.constraint(equalTo: dayImageView.bottomAnchor, constant: 16),
			dayView.widthAnchor.constraint(equalToConstant: 80),
			dayView.heightAnchor.constraint(equalToConstant: 55),
			
			nightImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
			nightImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -50),
			nightImageView.widthAnchor.constraint(equalToConstant: 80),
			nightImageView.heightAnchor.constraint(equalToConstant: 55),
			
			nightView.centerXAnchor.constraint(equalTo: nightImageView.centerXAnchor),
			nightView.topAnchor.constraint(equalTo: nightImageView.bottomAnchor, constant: 16),
			nightView.widthAnchor.constraint(equalToConstant: 80),
			nightView.heightAnchor.constraint(equalToConstant: 55)
		])
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.emitterManager = EmitterManager(superView: self.view)
		switch self.themeDelegate?.currentStyle() {
		case .light:
			selectDay()
		case .dark:
			selectNight()
		default:
			selectDay()
		}
	}
	
	deinit {
		print("ThemeViewController deinit")
	}
}
