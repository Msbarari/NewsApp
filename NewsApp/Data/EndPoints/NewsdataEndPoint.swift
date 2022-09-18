//
//  NewsdataEndPointProvider.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import Alamofire

enum NewsdataEndPoint: NewsEndPoint,EndPointResponse {
    
    
    typealias T = NewsDataResponse
    var responseType: NewsDataResponse.Type
    {
        return NewsDataResponse.self
    }
    var responseClassName: String
    {
        return "NewsDataResponse"
    }
    
    func getNewsEnum() ->  NewsEndPoint{
        return self
    }
    
case getNews(country:String,category:String,query :String?,page : Int)

    var httpMethod: HTTPMethod {
        switch self {
        case .getNews:
            return .get
        }

    }

    var baseURLString: String {
        switch self {
        case .getNews:
            return "https://newsdata.io"

        }
    }

    var path: String {
        switch self {
        case .getNews:
            return "/api/1/news?"
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
        case .getNews(let country,let category, let query,let page):
            return newsParameter(country,category,query,page)

        }
    }

    private func newsParameter(_ country:String,_ category:String,_ query :String?,_ page : Int) -> [String : Any]
    {
        var parameters  =
             [
                 "apikey":"pub_1508e9913474fcb85d810a8f1126e1a43e04",
                 "country":country,
                 "category":category,
                 "page":page,

             ] as [String : Any]

        if let query = query {
            parameters["q"] = query
        }
             return parameters
    }
}
