//
//  URLSessionManager .swift
//  ImageAI
//
//  Created by DoanhMac on 13/3/25.
//

import Foundation
import SwiftUI

final class URLSessionManager {
    static let shared = URLSessionManager()
    private init() {}
    
    private let baseUrlOld = "https://math.onewise.app/api/"
    private let baseURLNew = "https://new-rest.onewise.app/api/"
    private let TOKEN_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6MywiaWF0IjoxNzQxNDkxNDQ2fQ.ifBI5w5668ip1MVIf5EdFCFV396xr72y2KZJ_Qyslzw"
    
    //    func request(endpoint: APIEndpoint, body: [String: Any]? = nil) async throws -> Data {
    //        guard let url = URL(string: baseURL + endpoint.path) else {
    //            throw URLError(.badURL)
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = endpoint.method.rawValue
    //
    //        if let body = body {
    //            request.httpBody = try JSONSerialization.data(withJSONObject: body)
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        }
    //
    //        let (data, _) = try await URLSession.shared.data(for: request)
    //        return data
    //    }
    
    func requestOldApi(endpoint: APIEndpoint) async throws -> Data { //No body request
        guard let url = URL(string: baseUrlOld + endpoint.path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("Bearer \(TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func requestOldApi<T: Encodable>(endpoint: APIEndpoint, body: T? = nil) async throws -> Data {
        guard let url = URL(string: baseUrlOld + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        
        request.setValue("Bearer \(TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func requestNewApi<T: Encodable>(endpoint: APIEndpoint, body: T? = nil) async throws -> Data {
        guard let url = URL(string: baseURLNew + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        
        request.setValue("Bearer \(TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
