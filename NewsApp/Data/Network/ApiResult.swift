//
//  ApiResult.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation

enum ApiResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}
