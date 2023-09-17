//
//  EditProfileInteractor.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit
import Foundation

protocol EditProfileBusinessLogic: AnyObject {
	func makeState(requst: EditProfileModel.Request)
}

protocol EditProfileDataStore {
	func getUserPrifile() -> UserProfileProtocol?
	func setUserPhoto(image: UIImage?)
	func cancelEditPhoto()
	func tryAgainSaveData()
}

final class EditProfileInteractor: EditProfileBusinessLogic {
    
    private var presenter: EditProfilePresentationLogic?
	private var buffer: SaveData?
	private var storage: StorageProtocol?
	private var lastSavedPhoto: UIImage?

	private var userProfile: UserProfileProtocol?
	
	struct Dependencies {
		var storage: StorageProtocol?
		var presenter: EditProfilePresentationLogic?
		var userProfile: UserProfileProtocol?
	}
	
	init(dependencies: Dependencies?) {
		self.storage = dependencies?.storage
		self.presenter = dependencies?.presenter
		self.userProfile = dependencies?.userProfile
	}
	func makeState(requst: EditProfileModel.Request) {
		switch requst {
		case .edit:
			let profileData = ProfileModel.Response.ProfileData(
				title: "Edit Profile",
				userProfile: self.userProfile
			)
			self.presenter?.buildState(response: .edit(profileData))
		case .save:
			let profileData = ProfileModel.Response.ProfileData(
				title: "Saving data",
				userProfile: self.userProfile
			)
			self.presenter?.buildState(response: .wait(profileData))
		case .editPhoto:
			let profileData = ProfileModel.Response.ProfileData(
				title: "Edit Profile",
				userProfile: self.userProfile
			)
			self.presenter?.buildState(response: .editPhoto(profileData))
		case .fetch:
			fetchUser()
		case .cancel:
			self.storage?.cancel()
		case .saveNameBio(let userName, let userBio):
			self.userProfile?.userName = userName
			self.userProfile?.userBio = userBio
			self.makeState(requst: .save)
			saveUser(userName: self.userProfile?.userName, userBio: self.userProfile?.userBio, userPhoto: self.userProfile?.userPhoto?.pngData())
		}
	}
	
	private func saveUser(userName: String?, userBio: String?, userPhoto: Data?) {
		let saveData = SaveData(
			userBio: userBio,
			userName: userName,
			userPhoto: userPhoto
		)
		self.buffer = saveData
		self.storage?.save(user: saveData, completion: { [weak self] result in
			switch result {
			case .success(let savedData):
				self?.userProfile?.userBio = savedData.userBio
				self?.userProfile?.userName = savedData.userName
				if let savedPhoto = savedData.userPhoto {
					self?.userProfile?.userPhoto = UIImage(data: savedPhoto)
					self?.lastSavedPhoto = self?.userProfile?.userPhoto
				}
				self?.makeState(requst: .edit)
				self?.presenter?.buildState(response: .savedSeccess)
				print("Saved success!")
			case .failure(let error):
				print("Saved failure!", error.localizedDescription)
				self?.presenter?.buildState(response: .savedFailure)
			}
		})
	}
	
	private func fetchUser() {
		self.storage?.fetch(completion: { [weak self] result in
			switch result {
			case .success(let sevedData):
				self?.userProfile?.userBio = sevedData.userBio
				self?.userProfile?.userName = sevedData.userName
				if let savedPhoto = sevedData.userPhoto {
					self?.userProfile?.userPhoto = UIImage(data: savedPhoto)
				}
				self?.makeState(requst: .edit)
			case .failure(let error):
				print("Fetch failure!", error.localizedDescription)
				self?.makeState(requst: .edit)
			}
		})
	}
    
}

extension EditProfileInteractor: EditProfileDataStore {
	func setUserPhoto(image: UIImage?) {
		self.userProfile?.userPhoto = image
		self.makeState(requst: .edit)
	}
	
	func cancelEditPhoto() {
		makeState(requst: .edit)
	}
	
	func getUserPrifile() -> UserProfileProtocol? {
		return self.userProfile
	}
	
	func tryAgainSaveData() {
		saveUser(userName: self.userProfile?.userName, userBio: self.userProfile?.userBio, userPhoto: self.userProfile?.userPhoto?.pngData())
	}

}

/*
 func makeState(requst: ProfileModel.Request) {
	 switch requst {
	 case .fetch:
		 fetchUser()
	 case .start:
		 let profileData = ProfileModel.Response.ProfileData(
			 title: "My Profile",
			 userProfile: self.userProfile
		 )
		 self.presenter?.buildState(response: .start(profileData))
	 case .edit:
		 let profileData = ProfileModel.Response.ProfileData(
			 title: "Edit Profile",
			 userProfile: self.userProfile
		 )
		 self.presenter?.buildState(response: .edit(profileData))
	 case .save:
		 let profileData = ProfileModel.Response.ProfileData(
			 title: "Saving data",
			 userProfile: self.userProfile
		 )
		 self.presenter?.buildState(response: .wait(profileData))
	 case .editPhoto:
		 let profileData = ProfileModel.Response.ProfileData(
			 title: "Edit Profile",
			 userProfile: self.userProfile
		 )
		 self.presenter?.buildState(response: .editPhoto(profileData))
	 case .saveNameBio(let userName, let userBio):
		 makeState(requst: .save)
		 saveUser(userName: userName, userBio: userBio, userPhoto: self.userProfile?.userPhoto?.pngData())
	 case .cancel:
		 self.storage?.cancel()
		 self.userProfile?.userPhoto = self.lastSavedPhoto
		 makeState(requst: .start)
	 }
 }
 */
