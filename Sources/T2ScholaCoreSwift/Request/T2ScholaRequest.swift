import Foundation

protocol T2ScholaRequest: Request {}

extension T2ScholaRequest {
    var baseURL: URL {
        URL(string: "https://t2schola.titech.ac.jp")!
    }
}
