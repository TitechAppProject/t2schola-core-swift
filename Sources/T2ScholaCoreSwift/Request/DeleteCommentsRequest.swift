import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct DeleteCommentsRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = DeleteCommentsResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(commentId: Int, wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "core_comment_delete_comments",
            "comments[0]" : commentId //id of the comment (default: 0)
        ]
    }
}

public typealias DeleteCommentsResponse = [DeleteCommentsResponseWarning]?

public struct DeleteCommentsResponseWarning: Codable {
    public let item: String?
    public let itemid: Int?
    // The warning code can be used by the client app to implement specific behaviour.
    public let warningcode: String
    // Untranslated english message to explain the warning.
    public let message: String
}
