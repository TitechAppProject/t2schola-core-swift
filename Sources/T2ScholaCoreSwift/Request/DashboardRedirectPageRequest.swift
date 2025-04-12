//
//  LMSRedirectPageRequest.swift
//  ScienceTokyoPortalKit
//
//  Created by 中島正矩 on 2025/04/09.
//

import Foundation
import Kanna

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum LMSDashboardRedirectError: Error, Equatable {
    case parseHtml
    case invalidResponse
}

struct DashboardRedirectPageRequest: T2ScholaRequest {
    typealias RequestBody = DashboardRedirectPageRequestBody
    typealias ResponseBody = Void

    var method: HTTPMethod = .post

    var path: String { basePath + "/auth/saml2/sp/saml2-acs.php/lms.isct.ac.jp" }
    
    var requestBody: RequestBody

    let queryParameters: [String: Any]? = [:]        

    var headerFields: [String: String]? = [
        "Origin": baseHost,
        "Connection": "keep-alive",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        "Accept-Encoding": "br, gzip, deflate",
        "Accept-Language": "ja",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "cross-site",
        "Priority": "u=3, i"
    ]

    func decode(data: Data, responseUrl: URL?) throws {
        guard
            let doc = { () -> HTMLDocument? in
                do {
                    return try HTML(html: data, encoding: String.Encoding.utf8)
                } catch {
                    return nil
                }
            }()
        else {
            throw LMSDashboardRedirectError.parseHtml
        }

        // TODO: ポリシー同意画面の判定
        // ポリシーエラーのHTMLを入手できていないので判定部分のコードを書けていません
        // また，ポリシー同意判定をLoginRequestで行うかorここで行うかの議論も必要です

        guard let bodyHtml = doc.css("body").first?.innerHTML, bodyHtml.contains("ダッシュボード") || bodyHtml.contains("Dashboard")
        else {
            throw LMSDashboardRedirectError.invalidResponse
        }
    }

    init(htmlInputs: [HTMLInput]) {
        self.requestBody = DashboardRedirectPageRequestBody(
            query: htmlInputs.reduce(into: [String: Any]()) {
                $0[$1.name] = $1.value
            }
        )
    }
}

struct DashboardRedirectPageRequestBody: WwwFormUrlEncodedBody {
    public let query: [String: Any]
}

    
    
