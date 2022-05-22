import Foundation

struct UsersByFieldRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = UsersByFieldResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(userIds: [Int], wsToken: String) {
        var q: [String: Any] = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "core_user_get_users_by_field",
            "field" : "id"
        ]
        
        for userId in userIds.enumerated() {
            q["values[\(userId.offset)]"] = userId.element
        }
        
        queryParameters = q
    }
}

public typealias UsersByFieldResponse = [UserByFieldResponse]

public struct UserByFieldResponse: Decodable {
    let id: Int // ID of the user.
    let username: String? // The username.
    let firstname: String? // The first name(s) of the user.
    let lastname: String? // The family name of the user.
    let fullname: String // The fullname of the user.
    let email: String? // An email address - allow email as root@localhost.
    let address: String? // Postal address.
    let phone1: String? // Phone 1.
    let phone2: String? // Phone 2.
    let icq: String? // Icq number.
    let skype: String? // Skype id.
    let yahoo: String? // Yahoo id.
    let aim: String? // Aim id.
    let msn: String? // Msn number.
    let department: String? // Department.
    let institution: String? // Institution.
    let idnumber: String? // An arbitrary ID code number perhaps from the institution.
    let interests: String? // User interests (separated by commas).
    let firstaccess: Date? // First access to the site (0 if never).
    let lastaccess: Date? // Last access to the site (0 if never).
    let auth: String? // Auth plugins include manual, ldap, etc.
    let suspended: Bool? // Suspend user account, either false to enable user login or true to disable it.
    let confirmed: Bool? // Active user: 1 if confirmed, 0 otherwise.
    let lang: String? // Language code such as "en", must exist on server.
    let calendartype: String? // Calendar type such as "gregorian", must exist on server.
    let theme: String? // Theme name such as "standard", must exist on server.
    let timezone: String? // Timezone code such as Australia/Perth, or 99 for default.
    let mailformat: Int? // Mail format code is 0 for plain text, 1 for HTML etc.
    let description: String? // User profile description.
    let descriptionformat: Int? // Int format (1 = HTML, 0 = MOODLE, 2 = PLAIN or 4 = MARKDOWN).
    let city: String? // Home city of the user.
    let url: String? // URL of the user.
    let country: String? // Home country code of the user, such as AU or CZ.
    let profileimageurlsmall: String // User image profile URL - small version.
    let profileimageurl: String // User image profile URL - big version.
    // let customfields?: CoreUserProfileField[] // User custom fields (also known as user profile fields).
    // let preferences?: CoreUserPreference[] // Users preferences.
}
