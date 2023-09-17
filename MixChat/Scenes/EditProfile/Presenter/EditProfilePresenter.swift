//
//  EditProfilePresenter.swift
//  MixChat
//
//  Created by Михаил Фокин on 02.05.2023.
//

protocol EditProfilePresentationLogic: AnyObject {
	func buildState(response: EditProfileModel.Response)
}

final class EditProfilePresenter: EditProfilePresentationLogic {
    
	private weak var controller: EditProfileDisplayLogic?
    
    init(controller: EditProfileDisplayLogic?) {
        self.controller = controller
    }
    
	func buildState(response: EditProfileModel.Response) {
		switch response {
		case .edit(let profileData):
			let show = EditProfileModel.ViewModel.Show(
				title: profileData?.title,
				userProfile: profileData?.userProfile,
				rightButtonState: .choice,
				isTextFieldsFirstResponder: true
			)
			self.controller?.displayContent(show: .display(show))
		case .wait(let profileData):
			let show = EditProfileModel.ViewModel.Show(
				title: profileData?.title,
				userProfile: profileData?.userProfile,
				rightButtonState: .hidden,
				isTextFieldsFirstResponder: true
			)
			self.controller?.displayContent(show: .display(show))
		case .editPhoto(let profileData):
			let show = EditProfileModel.ViewModel.Show(
				title: profileData?.title,
				userProfile: profileData?.userProfile,
				rightButtonState: .choice,
				isTextFieldsFirstResponder: false
			)
			self.controller?.displayContent(show: .display(show))
		case .savedSeccess:
			self.controller?.displayContent(show: .savedSeccess)
		case .savedFailure:
			self.controller?.displayContent(show: .savedFailure)
		}
	}
}
