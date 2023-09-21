//
//  UserListView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 19/09/2023.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel = UserListViewModel()
    
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.users) { user in
                            NavigationLink(
                                destination: Text(user.firstName + " " + user.lastName),
                                label: {
                                    UserItem(user: user)
                                }).buttonStyle(PlainButtonStyle())
                        
                        }
                    }.padding()
                }
                
                
            }
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    UserListView()
}
