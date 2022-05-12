import XCTest
@testable import T2ScholaCoreSwift

final class T2ScholaTests: XCTestCase {
    let token = "7ea1522182832a9a1ff54d8ed04ed695"

    func testCourseContents() async throws {
        let t2Schola = T2Schola()
        T2Schola.changeToMock()

        let info = try await t2Schola.getSiteInfo(wsToken: token)
        let courses = try await t2Schola.getUserCourses(userId: info.userid, wsToken: token)
        for course in courses {
            _ = try await t2Schola.getCourseContents(courseId: course.id, wsToken: token)
        }
    }
}
