//
//  ProfilePresenter.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit

protocol ProfilePresentationLogic: AnyObject {
	func buildState(response: ProfileModel.Response)
}

protocol ProfileDataProtocol {
	var title: String? { get }
	var userProfile: UserProfileProtocol? { get }
}

final class ProfilePresenter: ProfilePresentationLogic {
    
	private weak var controller: ProfileDisplayLogic?
    
    init(controller: ProfileDisplayLogic?) {
        self.controller = controller
    }
    
	func buildState(response: ProfileModel.Response) {
		switch response {
		case .start(let profileData):
			let show = ProfileModel.ViewModel.Show(
				title: profileData?.title,
				userProfile: profileData?.userProfile
			)
			self.controller?.displayContent(show: .display(show))
		case .presentEditProfile:
			self.controller?.displayContent(show: .presentEditProfile)
		}
	}

}
