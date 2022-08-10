import XCTest
@testable import T2ScholaCoreSwift
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class T2ScholaTests: XCTestCase {
    let authSessionId = "SMS_getaccess03_76f8d8%3A%3Ad9390f42d20e1134507c7c0d9d2effff"
    let token = "7ea1522182832a9a1ff54d8ed04ed695"
    let userId = 999
    let userMockServer = true

    func testLogin() async throws {
        let t2Schola = T2Schola()
        if userMockServer { T2Schola.changeToMock() }

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

        let wsToken = try await t2Schola.getToken()
        XCTAssertEqual(wsToken, token)
    }
    
    func testUsersByFieldRequest() async throws {
        let t2Schola = T2Schola(
            apiClient: APIClientMock(
                mockString:
"""
[
  {
    "id": 999,
    "username": "00b00000",
    "fullname": "名無し 太郎 Nanashi Taro",
    "email": "nanashi.t.aa@m.titech.ac.jp",
    "department": "",
    "institution": "Tokyo Institute of Technology",
    "idnumber": "00B00000",
    "interests": "アプリ開発, Web開発",
    "auth": "eltitech",
    "confirmed": true,
    "lang": "ja",
    "theme": "",
    "timezone": "Asia/Tokyo",
    "mailformat": 1,
    "profileimageurlsmall": "https://t2schola.titech.ac.jp/pluginfile.php/999/user/icon/titech/f2",
    "profileimageurl": "https://t2schola.titech.ac.jp/pluginfile.php/999/user/icon/titech/f1",
    "customfields": [
      {
        "type": "text",
        "value": "工学院 〇〇系",
        "name": "所属",
        "shortname": "belongs"
      }
    ],
    "preferences": []
  }
]

"""
            )
        )

        let users = try await t2Schola.getUsersByField(userIds: [userId], wsToken: token)
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users[0].id, 999)
    }

    func testCourseContents() async throws {
        let t2Schola = T2Schola()
        if userMockServer { T2Schola.changeToMock() }

        let info = try await t2Schola.getSiteInfo(wsToken: token)
        let courses = try await t2Schola.getUserCourses(userId: info.userid, wsToken: token)
        for course in courses {
            _ = try await t2Schola.getCourseContents(courseId: course.id, wsToken: token)
            print("Finish Fetch Course Contents: \(course.id)")
        }
    }

    func testAssignments() async throws {
        let t2Schola = T2Schola()
        if userMockServer { T2Schola.changeToMock() }

        let assignments = try await t2Schola.getAssignments(wsToken: token)
        for course in assignments.courses {
            for assignment in course.assignments {
                let status = try await t2Schola.getAssignmentSubmissionStatus(assignmentId: assignment.id, userId: userId, wsToken: token)
                print("\(assignment.name) status: \(status.lastattempt?.submission?.status.rawValue ?? "")")
            }
        }
    }
    
    func testAddCommentRequest() async throws {
        let t2Schola = T2Schola(
            apiClient: APIClientMock(
                mockString:
#"""
[
    {
        "id": 12358,
        "content": "<div class=\"no-overflow\"><div class=\"text_to_html\">test comment あ !*'();:@&amp;=+$,/?%#[]</div></div>",
        "format": 0,
        "timecreated": 1660098833,
        "strftimeformat": "%Y年 %m月 %d日(%a) %H:%M",
        "profileurl": "https://t2schola.titech.ac.jp/user/view.php?id=10000&amp;course=20000",
        "fullname": "Fullname",
        "time": "2022年 08月 10日(水) 11:33",
        "avatar": "<a href=\"https://t2schola.titech.ac.jp/user/view.php?id=10000&amp;course=20000\" class=\"d-inline-block aabtn\"><img src=\"https://t2schola.titech.ac.jp/pluginfile.php/34988/user/icon/titech/f2?rev=1147621\" class=\"userpicture\" width=\"16\" height=\"16\" alt=\"test\" title=\"test\" /></a>",
        "userid": 10000,
        "delete": true
    }
]
"""#
                )
            )
        let response = try await t2Schola.addComments(instanceId: 80000, itemId: 500000, comment: "test comment あ !*'();:@&=+$,/?%#[]", wsToken: token)
        XCTAssertEqual(response.count, 1)
        XCTAssertEqual(response[0].id, 12358)
        XCTAssertEqual(response[0].format, 0)
        
    }
    

//    func testGetNotifications() async throws {
//        let t2Schola = T2Schola()
//        if userMockServer { T2Schola.changeToMock() }
//
//        let notifications = try await t2Schola.getPopupNotification(userId: userId, wsToken: token)
//        print("unread notification count: \(notifications.unreadcount)")
//        for message in notifications.notifications {
//            print(message.read ? "[read] \(message.subject)" : "[unread] \(message.subject)")
//        }
//    }
//
//    func testMarkNotificationAsRead() async throws {
//        let t2Schola = T2Schola()
//        if userMockServer { T2Schola.changeToMock() }
//
//        let response = try await t2Schola.markNotificationRead(notificationId: 1, wsToken: token)
//        if (response.warnings?.count == 0) {
//            print("Successfully marked")
//        }
//    }
}
