//
//  File.swift
//  
//
//  Created by nanashiki on 2020/12/13.
//
import Foundation
import T2ScholaCoreSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

print("Please input your titech portal AUTH_SESSION_ID cookie: ", terminator:"")
let authSessionId = readLine()!


let cookies: [HTTPCookie] = [
    HTTPCookie(
        properties: [
            .name: "AUTH_SESSION_ID",
            .domain: ".titech.ac.jp",
            .path: "/",
            .value: authSessionId
        ]
    )!
]


URLSession.shared.configuration.httpCookieStorage?.setCookies(cookies, for: URL(string: "https://t2schola.titech.ac.jp")!, mainDocumentURL: nil)

let t2Schola =  T2Schola()

t2Schola.getToken() { result in
    switch result {
    case let .success(wsToken):
        print("success, your wsToken is \(wsToken)")
        exit(0)
    case let .failure(error):
        print("error \(error)")
        exit(1)
    }
}


//t2Schola.getSiteInfo(wsToken: "df934be2fc30ee5e561ea0e8b86b7397") { result in
//    switch result {
//    case let .success(userId):
//        print("success, your userId is \(userId)")
//        exit(0)
//    case let .failure(error):
//        print("error \(error)")
//        exit(1)
//    }
//}

RunLoop.current.run()
