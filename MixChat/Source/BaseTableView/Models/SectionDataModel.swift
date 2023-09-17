//
//  Section.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

import Foundation

struct SectionDataModel: SectionData {
	var header: HeaderData?
	var elements: [CellData]?
	var footer: FooterData?
}
