import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct PopupNotificationRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = PopupNotificationResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(userId: Int, wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "useridto" : userId,
            "wsfunction" : "message_popup_get_popup_notifications"
        ]
    }
}

public struct PopupNotificationResponse: Codable {
    public let unreadcount: Int
    public let notifications: [PopupNotification]
}

public struct PopupNotification: Codable {
    public let subject: String
    public let fullmessage: String
    public let timecreated: Int
    public let read: Bool
    public let contexturl: String
}

