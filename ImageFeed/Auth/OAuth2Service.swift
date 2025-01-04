//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 10.12.2024.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int?
    let refreshToken: String?
}


final class OAuth2Service {
    static let shared = OAuth2Service()
    init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {return nil}
        
        var components = URLComponents(url: baseURL.appendingPathComponent("/oauth/token"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = components?.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URLRequest"])))
            return
        }
        
        // Создаем задачу URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Обработка ошибок
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Проверяем, что данные получены
            guard let data = data else {
                let noDataError = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print(noDataError.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response status"])
                print(statusError.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(statusError))
                }
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                let token = tokenResponse.accessToken
                
                let tokenStorage = OAuth2TokenStorage()
                tokenStorage.token = token
                
                DispatchQueue.main.async {
                    completion(.success(token))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

extension URLSession {
    func dataTask(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                let statusError = NSError(domain: "OAuth2Service", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(statusError))
                return
            }
            
            completion(.success(data ?? Data()))
        }
        task.resume()
    }
}

