//
//  HTTPClient.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
import SwiftUI
import Alamofire


class HTTPClient {
    
    private let profileUrl = "http://192.168.1.26:8000/v1/user/get-profile-bare"
    private let userUrl = "http://192.168.1.26:8000/v1/user/all-users"
    
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
    
    func getAllUsers(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        AF.request(userUrl, headers: headers).responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let userResponse):
                completion(.success(userResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

