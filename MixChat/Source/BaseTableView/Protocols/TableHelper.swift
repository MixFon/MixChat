//
//  TableHelper.swift
//  MixChat
//
//  Created by Михаил Фокин on 05.03.2023.
//

protocol TableHelperProtocol {
	func makeHeader() -> HeaderData?
	func makeFooter() -> FooterData?
	func makeSection() -> SectionData?
	func makeElements() -> [CellData]?
}
