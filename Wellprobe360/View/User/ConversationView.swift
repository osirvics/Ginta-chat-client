//
//  ConversationView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 19/09/2023.
//

import SwiftUI

struct ConversationView: View {
    @State var shouldShowLogout = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    private var customNavBar: some View{
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(Color(.systemGray))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.loggedInUser?.email ?? "")
                    .font(.system(size: 20, weight: .bold))
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(.systemGreen))
                Text("Online")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.lightGray))
            
            }
            Spacer()
            Button{
                shouldShowLogout.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                }
           
  }.padding(.horizontal)
            .actionSheet(isPresented: $shouldShowLogout, content: {
                
                ActionSheet(title: Text("Are you sure you want to logout?"), buttons: [
                    .destructive(Text("Logout"), action: {
                        print("Logout user")
                    }),
                    .cancel()
                ])
            })
        
    }
    
    
    private var conversationsScrollView: some View{
        ScrollView{
            
            ForEach(0..<20, id:  \.self) { num in
                VStack {
                    
                    NavigationLink(
                        destination: MessageView(),
                        label: {
                            HStack(spacing: 16){
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.systemGray), lineWidth: 1)
                                    )

                                VStack(alignment: .leading){
                                    Text("Udeme Etuk")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Message Sent to user")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(.gray))
                                }
                                Spacer()
                                Text("22d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }).buttonStyle(PlainButtonStyle())
                    
                 
                }
                Divider()
                    .padding(.vertical, 8)
            }.padding(.horizontal)
        }
    }
    
    
    var body: some View {
        NavigationStack{
            
            VStack {
                // Custom nav view
                customNavBar

                // ScrollView Section
                conversationsScrollView
           
                .navigationTitle("Conversations")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
            }.overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            print("New Message")
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(24)
                        })
                        .background(Color(.systemBlue))
                        .clipShape(Circle())
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            )
        }
    }
}

#Preview {
    ConversationView()
//        .preferredColorScheme(.dark)
//        .previewDevice("iPhone 12")
}
