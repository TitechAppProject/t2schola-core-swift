import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct SiteInfoRequest: RestAPIRequest {
    typealias RequestBody = Void
    typealias Response = SiteInfoResponse
    
    let method: HTTPMethod = .get
    
    let queryParameters: [String: Any]?
    
    init(wsToken: String) {
        queryParameters = [
            "moodlewsrestformat" : "json",
            "wstoken" : wsToken,
            "wsfunction" : "core_webservice_get_site_info"
        ]
    }
}

struct SiteInfoResponse: Decodable {
    let userid: Int
}
