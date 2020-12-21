//
//  File.swift
//  
//
//  Created by nanashiki on 2020/12/19.
//

import Foundation
import Kanna
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct LoginRequest: T2ScholaRequest {
    typealias RequestBody = Void
    
    let method: HTTPMethod = .get
    
    let path: String = "/admin/tool/mobile/launch.php"
    
    let queryParameters: [String: Any]?
    
    let headerFields: [String: String]? = [
        "User-Agent" : "Mozilla/5.0 (iPad; CPU OS 13_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Mobile/15E148 Safari/604.1"
    ]
    
    func decode(data: Data) throws -> LoginResponse {
        guard let doc = { () -> HTMLDocument? in
            do {
                return try HTML(html: data, encoding: String.Encoding.utf8)
            } catch {
                print(error)
                return nil
            }
        }() else {
//            throw NSError()
            fatalError()
        }
        print(String(data: data, encoding: .utf8))
        print(doc.css("a#launchapp").count)
        
        
        return LoginResponse(wsToken: "")
    }
    
    init() {
        queryParameters = [
            "service" : "moodle_mobile_app",
            "passport" : 7.11376419125993,
            "urlscheme" : "mmt2schola"
        ]
    }
}

struct LoginResponse {
    let wsToken: String
}
