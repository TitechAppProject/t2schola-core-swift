import Foundation

protocol T2ScholaRequest: Request {}

extension T2ScholaRequest {
    var basePath: String {
        isMockServer ? "" :"/2025"
    }
    var baseURL: URL {
        URL(string: "https://\(baseHost)")!
    }
}

var baseHost = "lms.s.isct.ac.jp"

var isMockServer = false

func changeToMockBaseHost() {
    isMockServer = true
    baseHost = "t2schola-mock.titech.app"
}
