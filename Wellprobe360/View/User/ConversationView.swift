//
//  ConversationView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 19/09/2023.
//

import SwiftUI
import Kingfisher

struct ConversationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var shouldShowLogout = false
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var conversationViewModel = ConversationViewModel()
    
    
    private var customNavBar: some View{
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(Color(.systemGray))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.loggedInUser?.firstName ?? "") \(viewModel.loggedInUser?.lastName ?? "")")
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
                        KeychainHelper.removeToken()
                    }),
                    .cancel()
                ])
            })
        
    }
    
    
    private var conversationsScrollView: some View{
        ScrollView{
            
            ForEach(conversationViewModel.directConversations) { directConversation in
                VStack {
                    
                    NavigationLink(
                        destination: MessageView(loggedInUser: authViewModel.loggedInUser!,
                                                 recipient: directConversation.participant1UUID == authViewModel.loggedInUser?.uuid ? directConversation.participant2UUID : directConversation.participant1UUID),
                        label: {
                            HStack(spacing: 16){
                                KFImage(URL(string: directConversation.participantProfilePicture ?? ""))
                                    .placeholder({
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 32))
                                                .padding(8)
                                                .overlay(RoundedRectangle(cornerRadius: 44)
                                                    .stroke(Color(.systemGray), lineWidth: 1)
                                        )
                                    })
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                                  

                                VStack(alignment: .leading){
                                    Text("\(directConversation.participantFirstname ) \(directConversation.participantLastname )")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text(directConversation.lastMessage)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                        .font(.system(.body)) // .body is an example, you can choose other text styles
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
