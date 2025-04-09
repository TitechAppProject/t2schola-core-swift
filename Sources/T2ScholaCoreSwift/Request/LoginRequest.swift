import Foundation
import Kanna

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum T2ScholaLoginError: Error, Equatable {
    case parseHtml
    case policy
    case parseUrlScheme(responseHTML: String, responseUrl: URL?)
    case parseToken(responseHTML: String, responseUrl: URL?)
}

struct LoginRequest: T2ScholaRequest {
    typealias RequestBody = Void

    let method: HTTPMethod = .get

    var path: String { basePath + "/admin/tool/mobile/launch.php" }

    let queryParameters: [String: Any]?

    let headerFields: [String: String]? = [
        "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
    ]

    func decode(data: Data, responseUrl: URL?) throws -> LoginResponse {
        guard
            let doc = { () -> HTMLDocument? in
                do {
                    return try HTML(html: data, encoding: String.Encoding.utf8)
                } catch {
                    return nil
                }
            }()
        else {
            throw T2ScholaLoginError.parseHtml
        }

        if let title = doc.title, title.contains("ポリシー") || title.contains("Policies") {
            throw T2ScholaLoginError.policy
        }

        guard
            let launchapp = doc.css("a#launchapp").first,
            let href = launchapp["href"],
            let decodedData = isMockServer ? Data(base64Encoded: href.replacingOccurrences(of: "mmt2schola://token=", with: "")) : Data(base64Encoded: href.replacingOccurrences(of: "moodlemobile://token=", with: "")),
            let decodedStr = String(data: decodedData, encoding: .utf8)
        else {
            throw T2ScholaLoginError.parseUrlScheme(responseHTML: String(data: data, encoding: .utf8) ?? "", responseUrl: responseUrl)
        }

        let splitedToken = decodedStr.components(separatedBy: ":::")

        if splitedToken.count > 1 {
            return LoginResponse(wsToken: splitedToken[1])
        } else {
            throw T2ScholaLoginError.parseToken(responseHTML: String(data: data, encoding: .utf8) ?? "", responseUrl: responseUrl)
        }
    }

    init() {
        queryParameters = [
            "service": "moodle_mobile_app",
            "passport": Double.random(in: 0...1000),
            "urlscheme": isMockServer ? "mmt2schola" : "moodlemobile",
        ]
    }
}
struct LoginResponse {
    let wsToken: String
}
