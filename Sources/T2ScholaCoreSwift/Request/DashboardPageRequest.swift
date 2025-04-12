//
//  LMSPageRequest.swift
//  ScienceTokyoPortalKit
//
//  Created by 中島正矩 on 2025/04/09.
//

import Foundation
import Kanna

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum LMSDashboardError: Error, Equatable {
    case parseHtml
}

struct DashboardPageRequest: T2ScholaRequest {
    typealias RequestBody = Void
    typealias Response = DashboardPageResponse

    var method: HTTPMethod = .get

    var path: String { basePath + "/" }

    let queryParameters: [String: Any]? = [:]

    let headerFields: [String: String]? = [
        "Connection": "keep-alive",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        "Accept-Encoding": "br, gzip, deflate",
        "Accept-Language": "ja-jp",
    ]
    
    func decode(data: Data, responseUrl: URL?) throws -> DashboardPageResponse {
        guard
            let doc = { () -> HTMLDocument? in
                do {
                    return try HTML(html: data, encoding: String.Encoding.utf8)
                } catch {
                    return nil
                }
            }()
        else {
            throw LMSDashboardError.parseHtml
        }
        
        if let bodyHtml = doc.css("body").first?.innerHTML, bodyHtml.contains("ダッシュボード") || bodyHtml.contains("Dashboard")
{
            return DashboardPageResponse(alreadyRequested: true, htmlInputs: [])
        }

        return DashboardPageResponse(alreadyRequested: false, htmlInputs: doc.css("input").map {
            HTMLInput(
                name: $0["name"] ?? "",
                type: HTMLInputType(rawValue: $0["type"] ?? "") ?? .text,
                value: $0["value"] ?? ""
                )
        })
    }
}

struct DashboardPageResponse {
    let alreadyRequested: Bool
    let htmlInputs: [HTMLInput]
}
