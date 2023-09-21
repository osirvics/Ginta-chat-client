//
//  ContentView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 17/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        
        
        Group{
            
            let accessToken = KeychainHelper.getToken()
            if accessToken == nil {
                LoginView()
            }
          
            
            TabView {
                UserListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
            
                ConversationView()
                    .tabItem {
                        Image(systemName: "envelope")
                        Text("Conversations")
                    }
                
                Text("Notifications")
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
            }
        }
    
        
        
        
    }
}

//#Preview {
//    ContentView().environmentObject(AuthViewModel.shared)
//}