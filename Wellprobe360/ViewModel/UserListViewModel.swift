//
//  UserListViewMobil.swift
//  Wellprobe360
//
//  Created by Victor Edu on 19/09/2023.
//

import SwiftUI

class UserListViewModel : ObservableObject {
    let httpClient = HTTPClient()
    @Published var users = [User]()
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        httpClient.getAllUsers { result in
            switch result {
            case .success(let userResponse):
                print("Total Users: \(userResponse.users.count)")
                self.users = userResponse.users
            case .failure(let error):
                print("Error fetching all users: \(error)")
            }
        }
    }
}
    
