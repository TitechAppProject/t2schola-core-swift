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
    
    public func login(cookies: [HTTPCookie]? = nil, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        apiClient.send(request: LoginRequest(), cookies: cookies) { result in
            switch result {
            case .success(_):
                completionHandler(.success(()))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
