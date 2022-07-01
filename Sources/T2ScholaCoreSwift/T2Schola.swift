import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct T2Schola {
    let apiClient: APIClient
    
    public init(urlSession: URLSession = .shared) {
        self.apiClient =  APIClientImpl(urlSession: urlSession)
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func getToken() async throws -> String {
        try await apiClient.send(request: LoginRequest()).wsToken
    }
    
    public func getSiteInfo(wsToken: String) async throws -> SiteInfoResponse {
        try await apiClient.send(request: SiteInfoRequest(wsToken: wsToken))
    }
    
    public func getUsersByField(userIds: [Int], wsToken: String) async throws -> UsersByFieldResponse {
        try await apiClient.send(request: UsersByFieldRequest(userIds: userIds, wsToken: wsToken))
    }
    
    public func getUserCourses(userId: Int, wsToken: String) async throws -> UserEnrolCoursesResponse {
        try await apiClient.send(request: UserEnrolCoursesRequest(userId: userId, wsToken: wsToken))
    }
    
    public func getCourseCategories(wsToken: String) async throws -> CourseCategoriesResponse {
        try await apiClient.send(request: CourseCategoriesRequest(wsToken: wsToken))
    }
    
    public func getCourseContents(courseId: Int, wsToken: String) async throws -> CourseContentsResponse {
        try await apiClient.send(request: CourseContentsRequest(courseid: courseId, wsToken: wsToken))
    }
    
    public func getAssignments(wsToken: String) async throws -> AssignmentsResponse {
        try await apiClient.send(request: AssignmentsRequest(wsToken: wsToken))
    }
    
    public func getAssignmentSubmissionStatus(assignmentId: Int, userId: Int, wsToken: String) async throws -> AssignmentSubmissionStatusResponse {
        try await apiClient.send(request: AssignmentSubmissionStatusRequest(assignmentId: assignmentId, userId: userId, wsToken: wsToken))
    }
    
    public func updateActivityCompletionStatusManually(moduleId: Int, completed: Bool, wsToken: String) async throws -> UpdateActivityCompletionStatusManuallyResponse {
        try await apiClient.send(request: UpdateActivityCompletionStatusManuallyRequest(moduleId: moduleId, completed: completed, wsToken: wsToken))
    }
    
    public func getPopupNotification(userId: Int, wsToken: String) async throws -> PopupNotificationResponse {
        try await apiClient.send(request: PopupNotificationRequest(userId: userId, wsToken: wsToken))
    }
    
    public func markNotificationRead(notificationId: Int, wsToken: String) async throws -> NotificationReadResponse {
        try await apiClient.send(request: NotificationReadRequest(notificationId: notificationId, wsToken: wsToken))
    }
    
    public func getSubmissionComments(instanceId: Int, itemId: Int, wsToken: String) async throws -> SubmissionCommentsResponse {
        try await apiClient.send(request: SubmissionCommentsRequest(instanceId: instanceId, itemId: itemId, wsToken: wsToken))
    }
    
    public func addComments(instanceId: Int, itemId: Int, comment: String, wsToken: String) async throws -> AddCommentsResponse {
        try await apiClient.send(request: AddCommentsRequest(instanceId: instanceId, itemId: itemId, comment: comment, wsToken: wsToken))
    }
    
    public func deleteComments(commentId: Int, wsToken: String) async throws -> DeleteCommentsResponse {
        try await apiClient.send(request: DeleteCommentsRequest(commentId: commentId, wsToken: wsToken))
    }

    public static func changeToMock() {
        changeToMockBaseHost()
    }
    
    public static var currentHost: String {
        baseHost
    }
}
