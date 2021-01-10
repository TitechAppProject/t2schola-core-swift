import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct UserEnrolCoursesRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = UserEnrolCoursesResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(userId: String, wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "core_enrol_get_users_courses",
            "userid" : userId
        ]
    }
}

public typealias UserEnrolCoursesResponse = [UserEnrolCourseResponse]

public struct UserEnrolCourseResponse {
    public let id: Int
    public let shortname: String
    public let fullname: String
    public let category: Int
    public let startdate: Date
    public let enddate: Date
}

extension UserEnrolCourseResponse: Codable {}
