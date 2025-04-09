import Foundation

protocol RestAPIRequest: T2ScholaRequest {}

extension RestAPIRequest {
    var path: String {
        basePath + "/webservice/rest/server.php"
    }
}
