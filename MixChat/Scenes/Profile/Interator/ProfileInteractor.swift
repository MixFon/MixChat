//
//  ProfileInteractor.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit

protocol ProfileBusinessLogic: AnyObject {
	func makeState(requst: ProfileModel.Request)
}

protocol ProfileDataStore {
	func getStorage() -> StorageProtocol?
	func getUserPrifile() -> UserProfileProtocol?
	func setUserPhoto(image: UIImage?)
}

final class ProfileInteractor: ProfileBusinessLogic {
    
	private var storage: StorageProtocol?
    private var presenter: ProfilePresentationLogic?
	private var userProfile: UserProfileProtocol?
	private var lastSavedPhoto: UIImage?
    
    struct Dependencies {
        var storage: StorageProtocol?
        var presenter: ProfilePresentationLogic?
        var userProfile: UserProfileProtocol?
    }
    
    init(dependencies: Dependencies?) {
        self.storage = dependencies?.storage
        self.presenter = dependencies?.presenter
		self.userProfile = dependencies?.userProfile
    }
	
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
		}
	}

	private func fetchUser() {
		self.storage?.fetch(completion: { [weak self] result in
			switch result {
			case .success(let sevedData):
				self?.userProfile?.userBio = sevedData.userBio
				self?.userProfile?.userName = sevedData.userName
				if let savedPhoto = sevedData.userPhoto {
					self?.userProfile?.userPhoto = UIImage(data: savedPhoto)
					self?.lastSavedPhoto = self?.userProfile?.userPhoto
				}
				self?.makeState(requst: .start)
			case .failure(let error):
				print("Fetch failure!", error.localizedDescription)
				self?.makeState(requst: .start)
			}
		})
	}
    
}

extension ProfileInteractor: ProfileDataStore {
	
	func setUserPhoto(image: UIImage?) {
		self.userProfile?.userPhoto = image
		self.makeState(requst: .start)
		self.presenter?.buildState(response: .presentEditProfile)
	}
	
	func getUserPrifile() -> UserProfileProtocol? {
		return self.userProfile
	}
	
	func getStorage() -> StorageProtocol? {
		return self.storage
	}
}
