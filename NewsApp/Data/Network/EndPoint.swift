//
//  EndPoint.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay
protocol Endpoint {

    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
    
}

extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}

protocol NewsEndPoint : Endpoint
{
     func getNewsEnum() -> NewsEndPoint
    var responseClassName: String { get  }
}

protocol EndPointResponse
{
    associatedtype T
    var responseType : T.Type { get  }
}

