//
//  AlamofireExtension.swift
//  NewsApp
//
//  Created by DG on 17/09/2022.
//

import Foundation
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data) {
    func expectingObject<T : Codable>(ofType type: T.Type) ->                                                                  Observable<ApiResult<T, ApiErrorMessage>>
    {
        return
        
        self.map { (httpURLResponse, data) -> ApiResult< T,ApiErrorMessage >
            in
            
            switch httpURLResponse.statusCode{
           
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                print("Sucess Response ---------- \n\(String(describing: String(data: data, encoding: .utf8)))")
                var object : T
                var _ : String?
                do{
                    object  = try JSONDecoder().decode(type, from: data)
                    return .success(object)
                }catch let jsonError as NSError
                {
                    let apiErrorMessage: ApiErrorMessage
                    apiErrorMessage = ApiErrorMessage(status: "Parsing Error", code: nil, message: jsonError.localizedDescription, results: nil)
                    return .failure(apiErrorMessage)
                }
                
            default:
                var object : ApiErrorMessage
                var _ : String?
                do{
                    object  = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                    return .failure(object)
                }catch let jsonError as NSError
                {
                    let apiErrorMessage: ApiErrorMessage
                    apiErrorMessage = ApiErrorMessage(status: "Parsing Error", code: nil, message: jsonError.localizedDescription,results: nil)
                    return .failure(apiErrorMessage)
                }

            }
        }
    }
}
