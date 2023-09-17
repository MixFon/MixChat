//
//  UserProfile.swift
//  MixChat
//
//  Created by Михаил Фокин on 06.03.2023.
//

import UIKit

protocol UserProfileProtocol {
	var userBio: String? { get set }
	var userName: String? { get set }
	var userPhoto: UIImage? { get set }
}
