import Foundation

protocol T2ScholaRequest: Request {}

extension T2ScholaRequest {
    var baseURL: URL {
        URL(string: "https://\(baseHost)")!
    }
}

var baseHost = "t2schola.titech.ac.jp"

func changeToMock() {
    baseHost = "nj2ohjnd59.execute-api.ap-northeast-1.amazonaws.com"
}
