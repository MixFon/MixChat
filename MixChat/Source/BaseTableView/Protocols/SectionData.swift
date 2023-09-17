//
//  SectionData.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import Foundation

protocol SectionData {
	var header: HeaderData? { get }
	var elements: [CellData]? { get }
	var footer: FooterData? { get }
}
