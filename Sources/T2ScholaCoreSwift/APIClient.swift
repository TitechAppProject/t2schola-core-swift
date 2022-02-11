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
    func send<R>(request: R) async throws -> R.Response where R: Request
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
    
    func send<R>(request: R) async throws -> R.Response where R: Request {
        let urlRequest = request.generate()
        
        let (data, response) = try await urlSession.data(for: urlRequest, delegate: nil)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.noResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIClientError.invalidStatusCode(httpResponse.statusCode)
        }

        do {
            return try request.decode(data: data)
        } catch {
            if let errorResponse = try? JSONDecoder().decode(T2ScholaAPIErrorResponse.self, from: data) {
                throw APIClientError.t2ScholaAPIError(errorResponse)
            } else {
                throw APIClientError.responseDecode(error)
            }
        }
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

    func send<R>(request: R) async throws -> R.Response where R: Request {
        if let error = self.error {
            throw error
        }
        
        for (key, value) in self.mockData {
            if R.self == key, let value = value as? R.Response {
                return value
            }
        }

        fatalError()
    }
}
#endif
