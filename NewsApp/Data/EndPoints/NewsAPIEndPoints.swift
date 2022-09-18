//
//  NewsAPIEndPoints.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import Alamofire
import RxRelay
import RxSwift

enum NewsAPIEndPoints: NewsEndPoint,EndPointResponse {
    
    var responseClassName: String
    {
        return "NewsapiResponse"
    }
    
    typealias T = NewsapiResponse
   
    var responseType: NewsapiResponse.Type
    {
        return NewsapiResponse.self
    }

    
    func getNewsEnum() ->  NewsEndPoint{
        return self
    }
    

case getNews(country:String?,category:String?,query :String?,page : Int,pageSize:Int)

    var httpMethod: HTTPMethod {
        switch self {
        case .getNews:
            return .get
        }

    }

    var baseURLString: String {
        switch self {
        case .getNews:
            return "https://newsapi.org"

        }
    }

    var path: String {
        switch self {
        case .getNews:
            return "/v2/top-headlines"
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getNews:
            return nil

        }
    }

    var body: [String : Any]? {
        switch self {
        case .getNews:
            return nil
        }
    }

    var parameters: [String: Any]?
    {
        switch self {
        case .getNews(let country,let category, let query,let page, let pageSize):
            return newsParameter(country,category,query,page,pageSize)

        }
    }

    private func newsParameter(_ country:String?,_ category:String?,_ query :String?,_ page : Int,_ pageSize:Int) -> [String : Any]
    {
        var parameters  =
             [
                 "apiKey":"7664508ce07747b4a62e9cc9f589e01f",
                 "page":page,
                 "pageSize": pageSize

             ] as [String : Any]
        if let country = country {
            parameters["country"] = country
        }
        if let category = category {
            parameters["category"] = category
        }
        if let query = query {
            parameters["q"] = query
        }
             return parameters
    }
}
