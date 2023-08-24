import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct WorkshopsRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = WorkshopsResponse

    let method: HTTPMethod = .get

    let queryParameters: [String: Any]?

    init(wsToken: String) {
        queryParameters = [
            "moodlewsrestformat": "json",
            "wstoken": wsToken,
            "wsfunction": "mod_workshop_get_workshops_by_courses",
        ]
    }
}

public struct WorkshopsResponse: Codable {
    public let workshops: [WorkshopResponse]

}

public struct WorkshopResponse: Codable {
    public let id: Int
    public let course: Int
    public let name: String
    public let intro: String?
    public let introformat: Int?
    public let lang: String?
    public let instructauthors: String?
    public let instructauthorsformat: Int?
    public let instructreviewers: String?
    public let instructreviewersformat: Int?
    public let timemodified: Date?
    public let phase: Int?
    public let useexample: Bool?
    public let usepeerassessment: Bool?
    public let useselfassessment: Bool?
    public let grade: Double?
    public let gradinggrade:Double?
    public let strategy: String?
    public let evaluation: String?
    public let gradedecimals: Int?
    public let submissiontypetext: Int?
    public let submissiontypefile: Int?
    public let nattachments: Int?
    public let submissionfiletypes: String?
    public let latesubmissions: Bool?
    public let maxbytes: Int?
    public let examplesmode: Int?
    public let submissionstart: Date?
    public let submissionend: Date?
    public let assessmentstart: Date?
    public let assessmentend: Date?
    public let phaseswitchassessment: Bool?
    public let conclusion: String?
    public let conclusionformat: Int?
    public let overallfeedbackmode: Int?
    public let overallfeedbackfiles: Int?
    public let overallfeedbackfiletypes: String?
    public let overallfeedbackmaxbytes: Int?
    public let coursemodule: Int?
    public let introfiles: [CoreWSExternalFile]?
    public let instructauthorsfiles: [CoreWSExternalFile]?
    public let instructreviewersfiles: [CoreWSExternalFile]?
}
