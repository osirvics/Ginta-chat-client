//
//  HTTPClient.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
import SwiftUI
import Alamofire


class HTTPClient {
    
    private let profileUrl = "\(BASE_URL.url)/v1/user/get-profile-bare"
    private let userUrl = "\(BASE_URL.url)/v1/user/all-users"
    
    private var headers: HTTPHeaders {
        if let storedToken = KeychainHelper.getToken() {
            return ["Authorization": "Bearer \(storedToken)"]
        } else {
            return [:]
        }
    }
    
    func getProfile(completion: @escaping (Result<User, Error>) -> Void) {
        AF.request(profileUrl, headers: headers).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func getAllUsers(completion: @escaping (Result<UserResponse, Error>) -> Void) {
//        AF.request(userUrl, headers: headers).responseDecodable(of: UserResponse.self) { response in
//            switch response.result {
//            case .success(let userResponse):
//                completion(.success(userResponse))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func getAllUsers() async throws -> UserResponse {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(userUrl, headers: headers).responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    continuation.resume(returning: userResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getAllConversations(completion: @escaping (Result<ConversationResponse, Error>) -> Void) {
        AF.request("\(BASE_URL.url)/v1/messaging/all-direct-conversations", headers: headers).responseDecodable(of: ConversationResponse.self) { response in
            switch response.result {
            case .success(let conversationResponse):
                completion(.success(conversationResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllMessages(participantUUID: String, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        AF.request("\(BASE_URL.url)/v1/messaging/direct-messages-all/\(participantUUID)", headers: headers).responseDecodable(of: MessageResponse.self) { response in
            switch response.result {
            case .success(let messageResponse):
                completion(.success(messageResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

