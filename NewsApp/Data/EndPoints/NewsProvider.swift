//
//  EndPointsProvider.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import RxSwift
import RxRelay


struct NewsProvider
{
    var network: Network
    
    
    
    init() {
        network = Network()
    }
    
    func getNews(page :Int) -> Observable<[ApiResult<News,ApiErrorMessage>]>  {
        
        var endPoints = [NewsEndPoint]()
        let first = NewsAPIEndPoints.getNews(country: "us", category: "sports", query: nil, page: page, pageSize: 10)
        let second = NewsdataEndPoint.getNews(country: "us", category: "sports", query: nil, page:page)
        
        endPoints.append(first)
        endPoints.append(second)
        
        return Observable.zip(mapResult(endPoints: endPoints))
        
    }
    
    func mapResult(endPoints : [NewsEndPoint]) -> [Observable<ApiResult<News,ApiErrorMessage>>]
    {
        var results : [Observable<ApiResult<News,ApiErrorMessage>>]  = [Observable<ApiResult<News,ApiErrorMessage>>]()
        
        for endPoint in endPoints {
            if (endPoint.responseClassName == "NewsapiResponse")
            {
                let result : Observable<ApiResult<NewsapiResponse,ApiErrorMessage>>  = network.request(endPoint: endPoint)
                
                results.append( result.map { apiResult in
                    switch apiResult
                    {
                    case let .success(newsapiResponse) :
                        return ApiResult(value: News.newsFromResponse(response: newsapiResponse))
                        
                    case let .failure(error):
                        return ApiResult(error: error)
                    }
                }
                )
            }
            else  if (endPoint.responseClassName == "NewsDataResponse")
            {
                let result : Observable<ApiResult<NewsDataResponse,ApiErrorMessage>>  = network.request(endPoint: endPoint)
                
                results.append( result.map { apiResult in
                    switch apiResult
                    {
                    case let .success(newsapiResponse) :
                        return ApiResult(value: News.newsFromResponse(response: newsapiResponse))
                        
                    case let .failure(error):
                        return ApiResult(error: error)
                    }
                }
                )
            }
            
        }
        return results
    }
}

