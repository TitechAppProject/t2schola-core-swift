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

DispatchQueue.global().async {
    T2Schola()
        .login(cookies: cookies) { result in
            switch result {
            case .success():
                print("success")
                exit(0)
            case let .failure(error):
                print("error \(error)")
                exit(1)
            }
        }
}


RunLoop.current.run()
