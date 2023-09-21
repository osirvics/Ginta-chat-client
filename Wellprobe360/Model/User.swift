//
//  User.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
//

import SwiftUI

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct UserResponse: Codable {
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "data"
    }
}

// MARK: - Datum
struct User: Codable, Identifiable {
    let password: String?
    let authType: AuthType
    let userType: UserType
    let lastLoginDatetime: String?
    let uuid: String
    let phoneNumber: String?
    let status: String?
    let id: Int
    let dateOfBirth, gender: String?
    let firstName: String
    let profileImage: String?
    let createdAt, lastName: String
    let usePreferredName: Bool
    let updatedAt, preferredName: String?
    let accountStatus: AccountStatus
    let email: String
    let emailVerified: Bool

    enum CodingKeys: String, CodingKey {
        case password
        case authType = "auth_type"
        case userType = "user_type"
        case lastLoginDatetime = "last_login_datetime"
        case uuid
        case phoneNumber = "phone_number"
        case status, id
        case dateOfBirth = "date_of_birth"
        case gender
        case firstName = "first_name"
        case profileImage = "profile_image"
        case createdAt = "created_at"
        case lastName = "last_name"
        case usePreferredName = "use_preferred_name"
        case updatedAt = "updated_at"
        case preferredName = "preferred_name"
        case accountStatus = "account_status"
        case email
        case emailVerified = "email_verified"
    }
}

enum AccountStatus: String, Codable {
    case active = "Active"
}

enum AuthType: String, Codable {
    case google = "Google"
    case local = "Local"
}

enum UserType: String, Codable {
    case client = "Client"
    case contractor = "Contractor"
}


struct AuthResponse: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct ErrorResponse: Codable {
    let detail: String
}


