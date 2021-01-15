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

enum RunType {
    case login
    case courseContents
}

let runType: RunType = .courseContents


let t2Schola =  T2Schola()

switch runType {
case .login:
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
case .courseContents:
    print("Please input your wsToken: ", terminator:"")
    let wsToken = readLine()!
    
    t2Schola.getSiteInfo(wsToken: wsToken) { result in
        switch result {
        case let .success(info):
            t2Schola.getUserCourses(userId: info.userid, wsToken: wsToken) { result in
                switch result {
                case let .success(courses):
                    courses.forEach { course in
                        t2Schola.getCourseContents(courseId: course.id, wsToken: wsToken) { result in
                            switch result {
                            case let .success(contents):
                                print(contents)
                                contents.forEach { content in
                                    content.modules.forEach { module in
                                        print("\(module.modname) \(module.contents?.count ?? -1)")
                                    }
                                }
//                                exit(0)
                            case let .failure(error):
                                print("error \(error)")
                                exit(1)
                            }
                        }
                    }
                    
                case let .failure(error):
                    print("error \(error)")
                    exit(1)
                }
            }
            
        case let .failure(error):
            print("error \(error)")
            exit(1)
        }
    }
    
    RunLoop.current.run()
}




