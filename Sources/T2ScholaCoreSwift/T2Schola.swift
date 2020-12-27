import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct T2Schola {
    let apiClient: APIClient
    
    public init() {
        self.apiClient =  APIClientImpl()
    }
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func getToken(completionHandler: @escaping (Result<String, Error>) -> Void) {
        apiClient.send(request: LoginRequest()) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response.wsToken))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getSiteInfo(wsToken: String, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        apiClient.send(request: SiteInfoRequest(wsToken: wsToken)) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response.userid))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
