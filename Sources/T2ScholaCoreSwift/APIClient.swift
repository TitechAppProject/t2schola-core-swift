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
    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, Error>) -> Void)
}

enum APIClientError: Error {
    case network
    case invalidStatusCode(_ code: Int)
}

struct APIClientImpl: APIClient {
    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, Error>) -> Void) {
        let urlRequest = request.generate()

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse, let data = data else {
                completionHandler(.failure(APIClientError.network))
                return
            }

            guard (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(APIClientError.invalidStatusCode(response.statusCode)))
                return
            }

            do {
                completionHandler(.success(try request.decode(data: data)))
            } catch {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
        
    }
}

#if DEBUG
struct APIClientMock: APIClient {
    private let mockData: [(Any.Type, Any)]
    private let error: Error?

    init(mockData: [(Any.Type, Any)]) {
        self.mockData = mockData
        self.error = nil
    }

    init(error: Error) {
        self.mockData = []
        self.error = error
    }

    func send<R: Request>(request: R, completionHandler: @escaping (Result<R.Response, Error>) -> Void) {
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
