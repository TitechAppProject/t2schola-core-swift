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

public enum APIClientError: Error {
    case noResponse
    case t2ScholaAPIError(_ response: T2ScholaAPIErrorResponse)
    case invalidStatusCode(_ code: Int)
    case responseDecode(_ error: Error)
}

public struct T2ScholaAPIErrorResponse: Decodable {
    public let errorcode: String
    public let exception: String
    public let message: String
}

struct APIClientImpl: APIClient {
    private let urlSession: URLSession
    private let urlSessionDelegate: URLSessionTaskDelegate
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.urlSessionDelegate = HTTPClientDelegate()
    }
    
    func send<R>(request: R) async throws -> R.Response where R: Request {
        let urlRequest = request.generate()
        
        let (data, response) = try await urlSession.data(for: urlRequest, delegate: urlSessionDelegate)

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

class HTTPClientDelegate: URLProtocol, URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Swift.Void
    ) {
        #if DEBUG
            print("")
            print("\(response.statusCode) \(task.currentRequest?.httpMethod ?? "") \(task.currentRequest?.url?.absoluteString ?? "")")
            print("  requestHeader: \(task.currentRequest?.allHTTPHeaderFields ?? [:])")
            print("  requestBody: \(String(data: task.originalRequest?.httpBody ?? Data(), encoding: .utf8) ?? "")")
            print("  responseHeader: \(response.allHeaderFields)")
            print("  redirect -> \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
            print("")
        #endif
        
        completionHandler(request)
    }

    func urlSession(_: URLSession, task: URLSessionTask, didFinishCollecting _: URLSessionTaskMetrics) {
        #if DEBUG
            print("")
            print("200 \(task.currentRequest!.httpMethod!) \(task.currentRequest!.url!.absoluteString)")
            print("  requestHeader: \(task.currentRequest!.allHTTPHeaderFields ?? [:])")
            print("  requestBody: \(String(data: task.originalRequest!.httpBody ?? Data(), encoding: .utf8) ?? "")")
            print("")
        #endif
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
