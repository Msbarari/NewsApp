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
                    apiErrorMessage = ApiErrorMessage(status: "Parsing Error", code: nil, message: jsonError.localizedDescription)
                    return .failure(apiErrorMessage)
                }
                
            default:
                // otherwise try
                let apiErrorMessage: ApiErrorMessage
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)}
                catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    //                apiErrorMessage = BackendErrorMessageModel(status: "failed", text: "Server Error", msgWithLanguage: "Server Error")
                    print("Response Error ---------- \n\(String(describing: String(data: data, encoding: .utf8)))")
                    apiErrorMessage = ApiErrorMessage(status: "System Error", code: nil, message: "")
                    
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
