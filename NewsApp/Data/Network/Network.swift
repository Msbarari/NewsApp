//
//  Network.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class Network{
    
    private let scheduler: ConcurrentDispatchQueueScheduler

    init() {
        
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }

    func request<T: Codable>(endPoint : Endpoint) -> Observable<ApiResult<T, ApiErrorMessage>>  {
        
        return RxAlamofire
            .request(endPoint.httpMethod, endPoint.url,parameters: endPoint.parameters,headers: endPoint.headers)
            .map({ dataReq in
                dataReq.response { dataRes in
                    print(dataReq.cURLDescription())
                }
                return dataReq
            })
            .debug()
            .observe(on: scheduler)
            .responseData()
            .expectingObject(ofType: T.self)
    }
    
}
