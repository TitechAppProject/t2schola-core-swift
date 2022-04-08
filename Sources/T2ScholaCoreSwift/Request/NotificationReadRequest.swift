import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct NotificationReadRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = NotificationReadResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(notificationId: Int, wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "notificationid" : notificationId,
            "wsfunction" : "core_message_mark_notification_read"
        ]
    }
}

public struct NotificationReadResponse: Codable {
    public let notificationid: Int
    public let warnings: [NotificationReadResponseWarning]
}

public struct NotificationReadResponseWarning: Codable {
    public let item: String
    public let itemid: Int
    public let warningcode: String
    public let message: String
}
