import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct T2Schola {
    let apiClient: APIClient
    
    public init(urlSession: URLSession = .shared) {
        self.apiClient =  APIClientImpl(urlSession: urlSession)
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func getToken(completionHandler: @escaping (Result<String, Error>) -> Void) {
        apiClient.send(request: LoginRequest()) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response.wsToken))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getSiteInfo(wsToken: String, completionHandler: @escaping (Result<SiteInfoResponse, Error>) -> Void) {
        apiClient.send(request: SiteInfoRequest(wsToken: wsToken)) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getUserCourses(userId: Int, wsToken: String, completionHandler: @escaping (Result<UserEnrolCoursesResponse, Error>) -> Void) {
        apiClient.send(request: UserEnrolCoursesRequest(userId: userId, wsToken: wsToken)) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getCourseCategories(wsToken: String, completionHandler: @escaping (Result<CourseCategoriesResponse, Error>) -> Void) {
        apiClient.send(request: CourseCategoriesRequest(wsToken: wsToken)) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getCourseContents(courseId: Int, wsToken: String, completionHandler: @escaping (Result<CourseContentsResponse, Error>) -> Void) {
        apiClient.send(request: CourseContentsRequest(courseid: courseId, wsToken: wsToken)) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public static func changeToMock() {
        changeToMockBaseHost()
    }
}
