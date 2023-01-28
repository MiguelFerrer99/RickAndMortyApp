//
//  Auth.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

enum AuthEndpoint {
    case login([String: String])
    case refreshToken([String: String])
    
    var endpoint: APIEndpoint {
        get {
            switch self {
            case .login(let parameters):
                return APIEndpoint(path: "/login",
                                httpMethod: .post,
                                parameters: parameters,
                                mock: "Login")
            case .refreshToken(let parameters):
                return APIEndpoint(path: "/refresh_token",
                                httpMethod: .post,
                                parameters: parameters,
                                mock: "RefreshToken")
            }
        }
    }
}
