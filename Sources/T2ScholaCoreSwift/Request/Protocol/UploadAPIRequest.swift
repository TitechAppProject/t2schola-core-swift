import Foundation

protocol UploadAPIRequest: T2ScholaRequest {}

extension UploadAPIRequest {
    var path: String {
        "webservice/upload.php"
    }
}
