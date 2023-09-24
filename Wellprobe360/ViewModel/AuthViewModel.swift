//
//  AuthViewModel.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
//

import SwiftUI
import Alamofire
import Valet  // Step 1: Import Valet

class AuthViewModel: ObservableObject {

    @Published var isAuthenticating = false
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var loggedInUser: User?
    
    let httpClient = HTTPClient()
    static let shared = AuthViewModel()

    // Step 2: Create an instance of Valet
    private let valet = Valet.valet(with: Identifier(nonEmpty: "Druidia")!, accessibility: .whenUnlocked)

    
    private init() {
        self.errorMessage = nil
        getProfile()
        getUsers()
      
    }
    
    func authenticate(username: String, password: String) {
        self.isAuthenticating = true
        self.isAuthenticated = false
        self.errorMessage = nil  // reset any previous errors
        
        print("Debug: username: \(username)")
        print("Debug: password: \(password)")
        
        let url = "\(BASE_URL.url)/v1/user/auth/token"
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseString { response in
//            print("Raw Response: \(response.value ?? "No response")")
        }.responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case .success(let authResponse):
                if !authResponse.accessToken.isEmpty && !authResponse.tokenType.isEmpty {
                    self.isAuthenticated = true
                    print("Debug: Access token: \(authResponse.accessToken)")
                    // Step 3: Save the access_token to the Keychain using Valet
                    
                    // Save the access_token to the Keychain using KeychainHelper
                   KeychainHelper.storeToken(authResponse.accessToken)
                    self.getUsers()
//                    self.getProfile()
                   
                    if let storedToken = KeychainHelper.getToken() {
                        print("Successfully retrieved stored access_token: \(storedToken)")
                    } else {
                        print("Failed to retrieve stored access_token or it is not set.")
                    }
                    self.getProfile()



                } else {
                    self.errorMessage = "Authentication failed."
                }
            case .failure(let error):
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        self.errorMessage = errorResponse.detail
                    } catch {
                        self.errorMessage = "Failed to connect please check your network."
                    }
                } else {
                    self.errorMessage = "Could not connect to the server."
                }
                print("Request error: \(error)")
            }
            self.isAuthenticating = false
        }
    }
    
    
    func getProfile(){
        self.httpClient.getProfile { result in
            switch result {
            case .success(let user):
                print("User Profile: \(user.firstName)")
                self.loggedInUser = user
                // Print the entire loggedInUser object or provide a default value if it's nil
                if let loggedInUser = self.loggedInUser {
                              print(loggedInUser)
                          } else {
                              print("No logged in user.")
                          }
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }
    
    func getUsers(){
        httpClient.getAllUsers { result in
            switch result {
            case .success(let userResponse):
                print("Total Users: \(userResponse.users.count)")
            
            case .failure(let error):
                print("Error fetching all users: \(error.localizedDescription)")
            }
        }
    }
    

}
