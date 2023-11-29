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
    case policy
}

public struct T2ScholaAPIErrorResponse: Decodable {
    public let errorcode: String
    public let exception: String
    public let message: String
}

struct APIClientImpl: APIClient {
    private let urlSession: URLSession
    #if !canImport(FoundationNetworking)
    private let urlSessionDelegate: URLSessionTaskDelegate
    #endif

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        #if !canImport(FoundationNetworking)
        self.urlSessionDelegate = HTTPClientDelegate()
        #endif
    }

    func send<R>(request: R) async throws -> R.Response where R: Request {
        let urlRequest = request.generate()

        let (data, response) = try await fetchData(request: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.noResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIClientError.invalidStatusCode(httpResponse.statusCode)
        }

        return try request.decode(data: data, responseUrl: httpResponse.url)
    }

    func fetchData(request: URLRequest) async throws -> (Data, URLResponse) {
        #if canImport(FoundationNetworking)
        return try await withCheckedThrowingContinuation { continuation in
            urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data ?? Data(), response!))
                }
            }.resume()
        }
        #else
        return try await urlSession.data(for: request, delegate: urlSessionDelegate)
        #endif
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
    private let mockString: String?
    private let mockResponseUrl: URL?
    private let error: APIClientError?

    init(mockData: [(Any.Type, Any)]) {
        self.mockData = mockData
        self.mockString = nil
        self.mockResponseUrl = nil
        self.error = nil
    }

    init(mockString: String, mockResponseUrl: URL?) {
        self.mockData = []
        self.mockString = mockString
        self.mockResponseUrl = mockResponseUrl
        self.error = nil
    }

    init(error: APIClientError) {
        self.mockData = []
        self.mockString = nil
        self.mockResponseUrl = nil
        self.error = error
    }

    func send<R>(request: R) async throws -> R.Response where R: Request {
        if let error = self.error {
            throw error
        }

        if let mockString = mockString {
            return try request.decode(data: mockString.data(using: .utf8)!, responseUrl: mockResponseUrl)
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
