import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct AssignmentsRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = AssignmentsResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "mod_assign_get_assignments"
        ]
    }
}

public struct AssignmentsResponse: Codable {
    public let courses: [AssignmentCourseResponse]
}

public struct AssignmentCourseResponse: Codable {
    public let id: Int
    public let assignments: [AssignmentResponse]
}

public struct AssignmentResponse: Codable {
    public let id: Int
    public let name: String
    public let intro: String?
    public let cutoffdate: Date
    public let duedate: Date
}
