import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct UploadFileRequest: UploadAPIRequest {
    typealias RequestBody = MultipartFormDatasBody
    typealias Response = UploadFilesResponse
    
    let method: HTTPMethod = .post
    
    var requestBody: MultipartFormDatasBody = []
    
    init(file: Data, mimeType: String, fileName: String, wsToken: String) {
        let fileBody = UploadFileRequestBody(data: file, name: "upfile", mimeType: mimeType, fileName: fileName)
        let tokenBody = UploadFileRequestBody(data: (wsToken.data(using: .utf8) ?? "".data(using: .utf8))!, name: "token", mimeType: "", fileName: "")
        requestBody.append(tokenBody)
        requestBody.append(fileBody)
    }
}

public struct UploadFileRequestBody: MultipartFormDataBody {
    public let data: Data
    public let name: String
    public let mimeType: String
    public let fileName: String
}

public typealias UploadFilesResponse = [UploadFileResponse]

public struct UploadFileResponse: Codable {
    public let component: String
    public let contextid: Int
    public let userid: String
    public let filearea: String
    public let filename: String
    public let filepath: String
    public let itemid: Int
    public let license: String? // File license.
    public let author: String? // File owner.
    public let source: String
    public let timecreated: Int? // Time created.
    public let filesize: Int? // File size.
}
