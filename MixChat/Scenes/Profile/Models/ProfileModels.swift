//
//  ProfileModels.swift
//  MixChat
//
//  Created by Михаил Фокин on 26.02.2023.
//

import UIKit

enum ProfileModel {

    enum Request {
		case start
		case fetch
    }
    
    enum Response {
		case start(ProfileDataProtocol?)
		case presentEditProfile
		
		struct ProfileData: ProfileDataProtocol {
			var title: String?
			var userProfile: UserProfileProtocol?
		}
    }
    
    enum ViewModel {
		case display(ProfileShow?)
		case presentEditProfile
		
		struct Show: ProfileShow {
			var title: String?
			var userProfile: UserProfileProtocol?
		}
    }
}
