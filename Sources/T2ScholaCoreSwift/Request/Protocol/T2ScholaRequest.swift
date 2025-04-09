import Foundation

protocol T2ScholaRequest: Request {}

extension T2ScholaRequest {
    var basePath: String {
        baseHost.contains("isct") ? "/2025" : ""
    }
    var baseURL: URL {
        URL(string: "https://\(baseHost)")!
    }
}

var baseHost = "lms.s.isct.ac.jp"

func changeToMockBaseHost() {
    baseHost = "t2schola-mock.titech.app"
}
