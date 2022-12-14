//
//  EndPointsProvider.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol NewsProviderProtocol
{
    func getNews(country : String?,category:String?,page :Int) -> Observable<ApiResult<News,ApiErrorMessage>>
}

struct NewsProvider : NewsProviderProtocol
{
    var network: Network
    var disposeBage = DisposeBag()
    
    
    
    init() {
        network = Network()
    }
    
    func getNews(country : String?,category:String?,page :Int) -> Observable<ApiResult<News,ApiErrorMessage>>  {
        
        var endPoints = [NewsEndPoint]()
        let first = NewsAPIEndPoints.getNews(country: country, category: category, query: nil, page: page, pageSize: 10)
        let second = NewsdataEndPoint.getNews(country: country, category: category, query: nil, page:page)
        
        endPoints.append(first)
        endPoints.append(second)
        
        return mapResult(endPoints: endPoints)
        
    }
    
    func mapResult(endPoints : [NewsEndPoint]) -> Observable<ApiResult<News,ApiErrorMessage>>
    {
        let empty :ApiResult<News,ApiErrorMessage> = ApiResult.success(News(page: 0, articales: []))
        
        var firstResult : Observable<ApiResult<News,ApiErrorMessage>> = Observable.of(empty)
        var secondResult : Observable<ApiResult<News,ApiErrorMessage>> = Observable.of(empty)
        
        for endPoint in endPoints {
            if (endPoint.responseClassName == "NewsapiResponse")
            {
                let result : Observable<ApiResult<NewsapiResponse,ApiErrorMessage>>  = network.request(endPoint: endPoint)
                firstResult =  result.map { apiResult in
                    switch apiResult
                    {
                    case let .success(newsapiResponse) :
                        return ApiResult(value: News.newsFromResponse(response: newsapiResponse))
                    case let .failure(error):
                        return ApiResult(error: error)
                    }
                }
                
            }else  if (endPoint.responseClassName == "NewsDataResponse")
            {
                let result : Observable<ApiResult<NewsDataResponse,ApiErrorMessage>>  = network.request(endPoint: endPoint)
                secondResult =  result.map { apiResult in
                    switch apiResult
                    {
                    case let .success(newsapiResponse) :
                        return ApiResult(value: News.newsFromResponse(response: newsapiResponse))
                    case let .failure(error):
                        return ApiResult(error: error)
                    }
                }
            }
        }
        return Observable.merge(firstResult,secondResult)
    }
}

