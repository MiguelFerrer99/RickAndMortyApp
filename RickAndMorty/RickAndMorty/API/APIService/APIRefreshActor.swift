//
//  APIActor.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 15/1/23.
//

actor APIRefreshActor {
    private let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    func refresh(with refreshToken: String) async throws -> String {
        do {
            let parameters: [String: String] = [
                "grant_type": "refresh_token",
                "client_id": getClientId(),
                "client_secret": getClientSecret(),
                "refresh_token": refreshToken
            ]
            let token = try await service.load(endpoint: AuthEndpoint.refreshToken(parameters).endpoint, of: TokenDTO.self)
            AppInfoManager.set(.access_token, token.accessToken)
            AppInfoManager.set(.refresh_token, token.refreshToken)
            return token.accessToken
        } catch let error {
            APILogger.thisError(error)
            AppInfoManager.clear()
            throw error
        }
    }
    
    private func getClientId() -> String {
        #if Demo
            return ""
        #elseif Production
            return ""
        #else
            return ""
        #endif
    }
    
    private func getClientSecret() -> String {
        #if Demo
            return ""
        #elseif Production
            return ""
        #else
            return ""
        #endif
    }
}
