//
//  NetworkingService.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import Alamofire
import AlamofireImage

class NetworkingService {
    
    typealias APIResponseCallback = (APIResponse) -> ()
    
    struct APIResponse {
        let success:Bool
        let error:Error?
        let message:String?
        let data: Data?
        init (success: Bool, error: Error? = nil, message: String? = nil, data: Data? = nil) {
            self.success = success
            self.error = error
            self.message = message
            self.data = data
        }
    }
    
    enum APIRequestError: Error {
        case invalidEndpoint
        case serializationFailed
        case responseIsNotHTTPURL
        case statusCodeNotSuccessful(error: Error?)
        case couldntCastAsData
        case dataIsNil
        case dataIsEmpty
        
        var description: String {
            return String(describing: self)
        }
    }

    private struct Authorisation {
        static let apiKey = "b743032cf35013dbaf8401f49b3e705c"
    }
    
    private enum Server {
        case development
        case production
        
        var baseURL: String {
            switch self {
                
            case .development:
                return "http://ws.audioscrobbler.com/2.0/?"
            case .production:
                return "http://ws.audioscrobbler.com/2.0/?"
            }
        }
    }
    
    private struct Prefix {
        static let Method           = "method="
        static let ApiKey           = "&api_key="
        static let FormatJSON       = "&format=json"
        
    }
    
    private struct Method {
        static let ArtistSearch     = "artist.search&artist="
    }
    
    // MARK: - Properties
    
    #if DEVELOPMENT
    private let baseURL = Server.development.baseURL
    #else
    private let baseURL = Server.production.baseURL
    #endif
    
    // MARK: - Public methods
    
    func getAllArtists(withName artistName: String, apiResponse: APIResponseCallback?) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let endpoint = baseURL + Prefix.Method + Method.ArtistSearch + artistName + Prefix.ApiKey + Authorisation.apiKey + Prefix.FormatJSON
        
        guard let url = URL(string: endpoint) else {
            os_log(.error, log: .network, "error: %s, function: %s, line: %i, \nfile: %s", APIRequestError.invalidEndpoint.description, #function, #line, #file)
            apiResponse?(APIResponse(success: false, error: APIRequestError.invalidEndpoint, message: APIRequestError.invalidEndpoint.description))
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let statusCode = response.response?.statusCode, 200...300 ~= statusCode {
                    guard let data = response.data else {
                        let error = APIRequestError.couldntCastAsData
                        os_log(.error, log: .network, "error: %s, function: %s, line: %i, \nfile: %s", error.description, #function, #line, #file)
                        return
                    }
                    os_log(.info, log: .network, "success, statusCode: %i, function: %s, line: %i, \nfile: %s", statusCode, #function, #line, #file);
                    apiResponse?(APIResponse(success: true, data: data))
                } else {
                    let error = APIRequestError.statusCodeNotSuccessful(error: nil)
                    os_log(.error, log: .network, "error: %s, function: %s, line: %i, \nfile: %s", error.description, #function, #line, #file)
                    apiResponse?(APIResponse(success: false, error: error))
                }
            case .failure(let error):
                os_log(.error, log: .network, "error: %s, function: %s, line: %i, \nfile: %s", error.localizedDescription, #function, #line, #file)
                apiResponse?(APIResponse(success: false, error: error))
            }
        }
    }

}
