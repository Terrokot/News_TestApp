//
//  JsonDataModel.swift
//  News
//
//  Created by Egor Tereshonok on 11/25/19.
//  Copyright © 2019 Egor Tereshonok. All rights reserved.
//


import Foundation

struct News: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Articles]?
}

struct Articles: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let publeshedAT: String?
}
