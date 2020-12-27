import Foundation

protocol RestAPIRequest: T2ScholaRequest {}

extension RestAPIRequest {
    var path: String {
        "webservice/rest/server.php"
    }
}
