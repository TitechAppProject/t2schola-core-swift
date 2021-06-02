import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct AssignmentSubmissionStatusRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = AssignmentSubmissionStatusResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(assignmentId: Int, userId: Int, wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "mod_assign_get_submission_status",
            "assignid": assignmentId,
            "userid": userId
        ]
    }
}

public struct AssignmentSubmissionStatusResponse: Codable {
    //public let gradingsummary: AssignmentSubmissionGradingSummary? // Grading information.
    public let lastattempt: AssignmentSubmissionLastAttempt? // Last attempt information.
    public let feedback: AssignmentSubmissionFeedback?; // Feedback for the last attempt.
    public let previousattempts: [AssignmentSubmissionPreviousAttempt]? // List all the previous attempts did by the user.
    // public let warnings?: CoreWSExternalWarning[];
}

public struct AssignmentSubmissionLastAttempt: Codable {
    public let submission: AssignmentSubmission? // Submission info.
}


public struct AssignmentSubmissionFeedback: Codable {
    public let grade: AssignmentSubmissionGrade? // Grade information.
    public let gradefordisplay: String? // Grade rendered into a format suitable for display.
    public let gradeddate: Date? // The date the user was graded.
//    public let plugins: [AddonModAssignPlugin]? // Plugins info.
}

public struct AssignmentSubmissionGrade: Codable {
    public let id: Int // Grade id.
    public let assignment: Int? // Assignment id.
    public let userid: Int // Student id.
    public let attemptnumber: Int // Attempt number.
    public let timecreated: Date // Grade creation time.
    public let timemodified: Date // Grade last modified time.
    public let grader: Int // Grader, -1 if grader is hidden.
    public let grade: String? // Grade.
    public let gradefordisplay: String?; // Grade rendered into a format suitable for display.
}

public struct AssignmentSubmissionPreviousAttempt: Codable {
    public let attemptnumber: Int // Attempt number.
    public let submission: AssignmentSubmission? // Submission info.
    public let grade: AssignmentSubmissionGrade? // Grade information.
//    public let feedbackplugins: [AddonModAssignPlugin]? // Feedback info.
}

public struct AssignmentSubmission: Codable {
    public let id: Int // Submission id.
    public let userid: Int // Student id.
    public let attemptnumber: Int // Attempt number.
    public let timecreated: Date // Submission creation time.
    public let timemodified: Date // Submission last modified time.
    public let status: AssignmentSubmissionStatus // Submission status.
//    public let groupid: Int // Group id.
//    public let assignment: Int? // Assignment id.
//    public let latest: Int? // Latest attempt.
//    public let plugins: [AddonModAssignPlugin]?; // Plugins.
//    public let gradingstatus: String? // @since 3.2. Grading status.
}

public enum AssignmentSubmissionStatus: String, Codable {
    case new = "new"
    case reopened = "reopened"
    case draft = "draft"
    case submitted = "submitted"
}
