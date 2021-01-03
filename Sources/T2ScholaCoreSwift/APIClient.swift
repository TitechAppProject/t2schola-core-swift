//
//  File.swift
//  
//
//  Created by nanashiki on 2020/12/13.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol APIClient {
    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, APIClientError>) -> Void)
}

enum APIClientError: Error {
    case network(_ errro: Error)
    case noResponse
    case t2ScholaAPIError(_ response: T2ScholaAPIErrorResponse)
    case invalidStatusCode(_ code: Int)
    case responseDecode(_ errro: Error)
}

struct T2ScholaAPIErrorResponse: Decodable {
    let errorcode: String
    let exception: String
    let message: String
}

struct APIClientImpl: APIClient {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, APIClientError>) -> Void) {
        let urlRequest = request.generate()

        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(APIClientError.network(error)))
                return
            }

            guard let response = response as? HTTPURLResponse, let data = data else {
                completionHandler(.failure(APIClientError.noResponse))
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(APIClientError.invalidStatusCode(response.statusCode)))
                return
            }

            do {
                completionHandler(.success(try request.decode(data: data)))
            } catch {
                if let errorResponse = try? JSONDecoder().decode(T2ScholaAPIErrorResponse.self, from: data) {
                    completionHandler(.failure(APIClientError.t2ScholaAPIError(errorResponse)))
                } else {
                    completionHandler(.failure(APIClientError.responseDecode(error)))
                }
            }
        }
        
        task.resume()
        
    }
}

#if DEBUG
struct APIClientMock: APIClient {
    private let mockData: [(Any.Type, Any)]
    private let error: APIClientError?

    init(mockData: [(Any.Type, Any)]) {
        self.mockData = mockData
        self.error = nil
    }

    init(error: APIClientError) {
        self.mockData = []
        self.error = error
    }

    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, APIClientError>) -> Void) {
        if let error = self.error {
            completionHandler(.failure(error))
        }

        self.mockData.forEach { (key, value) in
            if R.self == key, let value = value as? R.Response {
                completionHandler(.success(value))
                return
            }
        }
//        completionHandler(.failure(NSError()))
        fatalError()
    }
}
#endif
