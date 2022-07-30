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
        let t2Schola = T2Schola(
            apiClient: APIClientMock(
                mockString:
#"""
{
    "courses": [
        {
            "assignments": [
                {
                    "requiresubmissionstatement": 0,
                    "teamsubmission": 0,
                    "timemodified": 672633866,
                    "introformat": 1,
                    "markingallocation": 0,
                    "sendnotifications": 0,
                    "submissiondrafts": 0,
                    "cmid": 78927,
                    "allowsubmissionsfromdate": 675594000,
                    "requireallteammemberssubmit": 0,
                    "blindmarking": 0,
                    "duedate": 676281600,
                    "cutoffdate": -978307200,
                    "markingworkflow": 1,
                    "sendstudentnotifications": 1,
                    "completionsubmit": 1,
                    "nosubmissions": 0,
                    "name": "最終レポート",
                    "maxattempts": -1,
                    "intro": "<p dir=\"ltr\" style=\"text-align: left;\">基礎実験とアドバンス実験の内容を合わせて、レポートにまとめてください(ファイル提出)</p>",
                    "attemptreopenmethod": "none",
                    "id": 12662,
                    "introfiles": [],
                    "introattachments": [],
                    "grade": 100,
                    "teamsubmissiongroupingid": 0,
                    "gradingduedate": -978307200,
                    "revealidentities": 0,
                    "sendlatenotifications": 0,
                    "preventsubmissionnotingroup": 0,
                    "hidegrader": 0,
                    "course": 21596
                }
            ],
            "id": 21596,
            "timemodified": 680815935,
            "shortname": "MAT.C350[2022]",
            "fullname": "セラミックス実験第一 / Ceramics Laboratory I"
        }
    ]
}

"""#
                )
        )
        if userMockServer { T2Schola.changeToMock() }

        let assignments = try await t2Schola.getAssignments(wsToken: token)
        let t2Schola_ = T2Schola(
            apiClient: APIClientMock(
                mockString:
#"""
{
  "lastattempt": {
    "submission": {
      "id": 638369,
      "userid": 1,
      "attemptnumber": 0,
      "timecreated": 1653913737,
      "timemodified": 1654167496,
      "status": "submitted",
      "groupid": 0,
      "assignment": 12662,
      "latest": 1,
      "plugins": [
        {
          "type": "file",
          "name": "ファイル提出",
          "fileareas": [
            {
              "area": "submission_files",
              "files": [
                {
                  "filename": "file.pdf",
                  "filepath": "/",
                  "filesize": 27539461,
                  "fileurl": "https://t2schola.titech.ac.jp/webservice/pluginfile.php/189900/assignsubmission_file/submission_files/638369/file.pdf",
                  "timemodified": 1654167496,
                  "mimetype": "application/pdf",
                  "isexternalfile": false
                }
              ]
            }
          ]
        },
        {
          "type": "comments",
          "name": "提出コメント"
        }
      ]
    },
    "submissiongroupmemberswhoneedtosubmit": [],
    "submissionsenabled": true,
    "locked": false,
    "graded": false,
    "canedit": true,
    "caneditowner": true,
    "cansubmit": false,
    "extensionduedate": 0,
    "blindmarking": false,
    "gradingstatus": "released",
    "usergroups": []
  },
  "feedback": {
    "grade": {
      "id": 481445,
      "assignment": 12662,
      "userid": 18174,
      "attemptnumber": 0,
      "timecreated": 1654147811,
      "timemodified": 1656664622,
      "grader": -1,
      "grade": "-1.00000"
    },
    "gradefordisplay": null,
    "gradeddate": null,
    "plugins": [
      {
        "type": "comments",
        "name": "フィードバックコメント",
        "fileareas": [
          {
            "area": "feedback",
            "files": []
          }
        ],
        "editorfields": [
          {
            "name": "comments",
            "description": "フィードバックコメント",
            "text": "",
            "format": 1
          }
        ]
      },
      {
        "type": "offline",
        "name": "オフライン評定ワークシート"
      },
      {
        "type": "file",
        "name": "フィードバックファイル",
        "fileareas": [
          {
            "area": "feedback_files",
            "files": [
              {
                "filename": "file.pdf",
                "filepath": "/",
                "filesize": 27695725,
                "fileurl": "https://t2schola.titech.ac.jp/webservice/pluginfile.php/189900/assignfeedback_file/feedback_files/481445/file.pdf",
                "timemodified": 1655695382,
                "mimetype": "application/pdf",
                "isexternalfile": false
              }
            ]
          }
        ]
      }
    ]
  },
  "warnings": []
}

"""#
                )
        )
        for course in assignments.courses {
            for assignment in course.assignments {
                let status = try await t2Schola_.getAssignmentSubmissionStatus(assignmentId: assignment.id, userId: userId, wsToken: token)
                print("\(assignment.name) status: \(status.lastattempt?.submission?.status.rawValue ?? "")")
            }
        }
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
