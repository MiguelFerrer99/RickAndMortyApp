//
//  APIService.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

enum APIServiceError: Error {
    case mockNotFound
    case missingToken
    case invalidToken
    case invalidResponse
    case errorDecodable
    case errorData(Data)
    
    var localizedDescription: String {
        switch self {
        case .mockNotFound: return "Mock not found"
        case .missingToken: return "Access Token not found"
        case .invalidToken: return "Access Token not valid"
        case .invalidResponse: return "Response not expected"
        case .errorDecodable: return "Error while decoding object. Check your DTO"
        case .errorData(let data): return "Error reponse with data: \(data.prettyPrintedJSONString ?? "")"
        }
    }
    
    var data: Data {
        switch self {
        case .errorData(let data): return data
        default: return Data()
        }
    }
}

final class APIService {
    static let shared = APIService(authManager: APIAuthManager())
    
    let authManager: APIAuthManager
    
    private init(authManager: APIAuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - loadAuthorized - Call secured API
    func loadAuthorized<T: Decodable>(endpoint: APIEndpoint, of type: T.Type, allowRetry: Bool = true) async throws -> T {
        var request = endpoint.request
        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        let token = try await authManager.validToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        APILogger.thisCall(request)
        #if Demo
            return try await loadDemo(endpoint: endpoint, of: T.self)
        #else
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let response = urlResponse as? HTTPURLResponse else {
                APILogger.thisError(APIServiceError.invalidResponse)
                throw APIServiceError.invalidResponse
            }
            if response.statusCode == 401 {
                if allowRetry {
                    _ = try await authManager.refreshToken()
                    return try await loadAuthorized(endpoint: endpoint, of: type, allowRetry: false)
                }
            }
            APILogger.thisResponse(response, data: data)
            let decoder = JSONDecoder()
            var parsedData: T!
            do {
                parsedData = try decoder.decode(T.self, from: data)
            } catch {
                if (200..<300).contains(response.statusCode) {
                    APILogger.thisError(APIServiceError.errorDecodable)
                    throw APIServiceError.errorDecodable
                } else {
                    APILogger.thisError(APIServiceError.errorData(data))
                    throw APIServiceError.errorData(data)
                }
            }
            return parsedData
        #endif
    }
    
    // MARK: - load - Call unprotected API
    func load<T: Decodable>(endpoint: APIEndpoint, of type: T.Type) async throws -> T {
        var request = endpoint.request
        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        APILogger.thisCall(request)
        #if Demo
            return try await loadDemo(endpoint: endpoint, of: T.self)
        #else
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let response = urlResponse as? HTTPURLResponse else {
                APILogger.thisError(APIServiceError.invalidResponse)
                throw APIServiceError.invalidResponse
            }
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                APILogger.thisResponse(response, data: data)
                return parsedData
            } catch {
                APILogger.thisError(error)
                throw APIServiceError.errorDecodable
            }
        #endif
    }
}

private extension APIService {
    // MARK: - loadDemo - Call mocked responses
    func loadDemo<T: Decodable>(endpoint: APIEndpoint, of type: T.Type) async throws -> T {
        guard let url = Bundle.main.url(forResource: endpoint.mock, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            APILogger.thisError(APIServiceError.mockNotFound)
            throw APIServiceError.mockNotFound
        }
        do {
            let parsedData = try JSONDecoder().decode(T.self, from: data)
            guard let url = URL(string: "\(endpoint.mock)_Mock"),
                  let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                APILogger.thisError(APIServiceError.invalidResponse)
                throw APIServiceError.invalidResponse
            }
            APILogger.thisResponse(response, data: data)
            return parsedData
        } catch {
            APILogger.thisError(error)
            throw APIServiceError.errorDecodable
        }
    }
}
