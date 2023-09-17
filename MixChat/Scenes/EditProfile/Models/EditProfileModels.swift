//
//  EditProfileModels.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

import UIKit

enum EditProfileModel {
	
    enum Request {
		 case edit
		 case save
		 case fetch
		 case cancel
		 case editPhoto
		 case saveNameBio(String?, String?)
    }
    
    enum Response {
		 case wait(ProfileDataProtocol?)
		 case edit(ProfileDataProtocol?)
		 case editPhoto(ProfileDataProtocol?)
		 case savedSeccess
		 case savedFailure
		 
		 struct ProfileData: ProfileDataProtocol {
			 var title: String?
			 var userProfile: UserProfileProtocol?
		 }
    }
    
    enum ViewModel {
		case display(EditProfileShow?)
		case savedSeccess
		case savedFailure
		
		struct Show: EditProfileShow {
			var title: String?
			var userProfile: UserProfileProtocol?
			var rightButtonState: RightItem?
			var isTextFieldsFirstResponder: Bool?
		}
    }
}
