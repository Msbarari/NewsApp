//
//  ApiErrorMessage.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation

struct ApiErrorMessage: Codable {
    let status, code, message: String?
}
