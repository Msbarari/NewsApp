//
//  ApiErrorMessage.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation

struct ApiErrorMessage: Codable {
    let status, code: String?
    let message: String?
    let results: NewsDataResponseResults?

    var messageDescription : String
    {
        if let message = message {
            return message
        }
        else
        {
            return  results?.message ?? ""
        }
    }
    
    
}
// MARK: - NewsDataResponseResults
struct NewsDataResponseResults: Codable {
    let message, code: String
}
