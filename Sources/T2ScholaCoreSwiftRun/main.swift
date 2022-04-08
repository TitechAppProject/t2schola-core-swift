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
    case assignments
    case notifications
}

let runType: RunType = .notifications

let t2Schola =  T2Schola()
// T2Schola.changeToMock()

switch runType {
case .login:
    print("Please input your titech portal AUTH_SESSION_ID cookie: ", terminator:"")
    let authSessionId = readLine()!

    let cookies: [HTTPCookie] = [
        HTTPCookie(
            properties: [
                .name: "AUTH_SESSION_ID",
                .domain: "\(T2Schola.currentHost)",
                .path: "/",
                .value: authSessionId
            ]
        )!
    ]

    URLSession.shared.configuration.httpCookieStorage?.setCookies(cookies, for: URL(string: "https://\(T2Schola.currentHost)")!, mainDocumentURL: nil)
    Task {
        do {
            let wsToken = try await t2Schola.getToken()
            print("success, your wsToken is \(wsToken)")
            exit(0)
        } catch {
            print("error \(error)")
            exit(1)
        }
    }
case .courseContents:
    print("Please input your wsToken: ", terminator:"")
    let wsToken = readLine()!
    
    Task {
        do {
            let info = try await t2Schola.getSiteInfo(wsToken: wsToken)
            let courses = try await t2Schola.getUserCourses(userId: info.userid, wsToken: wsToken)
            for course in courses {
                let contents = try await t2Schola.getCourseContents(courseId: course.id, wsToken: wsToken)
                contents.forEach { content in
                    print(content.name + " module count:" + "\(content.modules.count)")
                    content.modules.forEach { module in
                        print("  " + module.name)
                        print("    " + "\(module.modname) \(module.contents?.count ?? -1)")
                        print("      " + (module.description ?? ""))
                    }
                }
            }
            exit(0)
        } catch {
            print("error \(error)")
            exit(1)
        }
    }
case .assignments:
    print("Please input your wsToken: ", terminator:"")
    let wsToken = readLine()!
    
    Task {
        do {
            let info = try await t2Schola.getSiteInfo(wsToken: wsToken)
            let assignments = try await t2Schola.getAssignments(wsToken: wsToken)
            for course in assignments.courses {
                for assignment in course.assignments {
                    let status = try await t2Schola.getAssignmentSubmissionStatus(assignmentId: assignment.id, userId: info.userid, wsToken: wsToken)
                    print("\(assignment.name) status: \(status.lastattempt?.submission?.status.rawValue ?? "")")
                }
            }
            exit(0)
        } catch {
            print("error \(error)")
            exit(1)
        }
    }
case .notifications:
    print("Please input your wsToken: ", terminator:"")
    let wsToken = readLine()!
    
    Task {
        do {
            let info = try await t2Schola.getSiteInfo(wsToken: wsToken)
            let notifications = try await t2Schola.getPopupNotification(userId: info.userid, wsToken: wsToken)
            print("unread notification count: \(notifications.unreadcount)")
            for message in notifications.notifications {
                print(message.read ? "[read] \(message.subject)" : "[unread] \(message.subject)")
            }
            exit(0)
        } catch {
            print("error \(error)")
            exit(1)
        }
    }
}

RunLoop.current.run()
