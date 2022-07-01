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
    public let gradingsummary: [AssignmentSubmissionGradingSummary]? // Grading information.
    public let lastattempt: AssignmentSubmissionLastAttempt? // Last attempt information.
    public let feedback: AssignmentSubmissionFeedback?; // Feedback for the last attempt.
    public let previousattempts: [AssignmentSubmissionPreviousAttempt]? // List all the previous attempts did by the user.
    public let assignmentdata: AssignmentSubmissionStatusData? // @since 4.0. Extra information about assignment.
    public let warnings: [AssignmentSubmissionStatusResponseWarning]?
}

public struct AssignmentSubmissionGradingSummary: Codable {
    public let participantcount: Int // Number of users who can submit.
    public let submissiondraftscount: Int // Number of submissions in draft status.
    public let submissionsenabled: Bool // Whether submissions are enabled or not.
    public let submissionssubmittedcount: Int // Number of submissions in submitted status.
    public let submissionsneedgradingcount: Int // Number of submissions that need grading.
    // warnofungroupedusers: string | boolean; // Whether we need to warn people about groups.
}

public struct AssignmentSubmissionStatusData: Codable {
    public let attachments: AssignmentSubmissionStatusDataAttachments? // Intro and activity attachments.
    public let activity: String? // Text of activity.
    public let activityformat: Int? // Format of activity.
}

public struct AssignmentSubmissionStatusDataAttachments: Codable {
    public let intro: [CoreWSExternalFile]? // Intro attachments files.
    public let activity: [CoreWSExternalFile]? // Activity attachments files.
}

public struct AssignmentSubmissionStatusResponseWarning: Codable {
    public let item: String?
    public let itemid: Int?
    // The warning code can be used by the client app to implement specific behaviour.
    public let warningcode: String
    // Untranslated english message to explain the warning.
    public let message: String
}


public struct AssignmentSubmissionLastAttempt: Codable {
    public let submission: AssignmentSubmission? // Submission info.
}


public struct AssignmentSubmissionFeedback: Codable {
    public let grade: AssignmentSubmissionGrade? // Grade information.
    public let gradefordisplay: String? // Grade rendered into a format suitable for display.
    public let gradeddate: Date? // The date the user was graded.
    public let plugins: [AddonModAssignPlugin]? // Plugins info.
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
    public let feedbackplugins: [AddonModAssignPlugin]? // Feedback info.
}

public struct AssignmentSubmission: Codable {
    public let id: Int // Submission id.
    public let userid: Int // Student id.
    public let attemptnumber: Int // Attempt number.
    public let timecreated: Date // Submission creation time.
    public let timemodified: Date // Submission last modified time.
    public let status: AssignmentSubmissionStatus // Submission status.
    public let groupid: Int // Group id.
    public let assignment: Int? // Assignment id.
    public let latest: Int? // Latest attempt.
    public let plugins: [AddonModAssignPlugin]?; // Plugins.
    public let gradingstatus: String? // @since 3.2. Grading status.
    public let timestarted: Int? // @since 4.0. Submission start time.
}

public struct AddonModAssignPlugin: Codable {
    public let type: String // Submission plugin type.
    public let name: String // Submission plugin name.
    public let fileareas: [AddonModAssignPluginFilearea]? // Fileareas.
    public let editorfields: [AddonModAssignPluginEditorfield]? // Editorfields.
    
}

public struct AddonModAssignPluginFilearea: Codable {
    public let area: String // File area.
    public let files: [CoreWSExternalFile]?
}

public struct AddonModAssignPluginEditorfield: Codable {
    public let name: String // Field name.
    public let description: String // Field description.
    public let text: String // Field value.
    public let format: Int // Text format (1 = HTML, 0 = MOODLE, 2 = PLAIN or 4 = MARKDOWN).
}
    

public enum AssignmentSubmissionStatus: String, Codable {
    case new = "new"
    case reopened = "reopened"
    case draft = "draft"
    case submitted = "submitted"
}
