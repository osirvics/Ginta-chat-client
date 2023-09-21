//
//  MessageView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var viewModel = MessageViewModel()
    @State var chatText = ""
    

    var body: some View {
        
        
        NavigationStack {
            VStack {
                
                messageListView
                Divider()
                
                chatInputView
            }
            .onAppear(perform: connectToWebSocket)
            Divider()
            //            .background(Color(.systemGroupedBackground))
                .background(Color(.init(white: 0.95, alpha: 1)))
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var messageListView: some View{
        ScrollView{
            ForEach(0..<20) { num in
                //change this
                var b = false
                if b {
                    HStack{
                        Spacer()
                        HStack {
                            
                            Text("Message is what we see \(num)")
                                .padding(.vertical, 8)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(.systemBlue))
                        .clipShape(ChatBubble(isCurrentUser:  b))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                else{
                    HStack{
                        HStack {
                            Text("Message is what we see \(num)")
                                .padding(.vertical, 8)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(ChatBubble(isCurrentUser:  b))
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
            }
            
            HStack{Spacer()}
        }
    }
    
    private var chatInputView: some View{
        HStack{
            // Upload Icon
            Button(action: {
              
            
            }, label: {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .frame(width: 25, height: 25)
            })
            
            TextField("Message...", text: $chatText)
                .padding(12)
                .background(Color(.systemGray4))
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Button(action: {
                viewModel.send(messageEvent: sendMessage())
            }, label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color(.systemBlue))
                    .clipShape(Circle())
            })
        }.padding(.horizontal)
    }
    
    func sendMessage() -> MessageEvent {
        let attachment = Attachment(
            fileURL: "wellprobe360/wellprobe360-profile-image-upload-folder/ac41039d-add0-43ca-bb2b-88cfc7fea9f4.jpeg",
            fileSize: 1024,
            fileType: "image/jpeg",
            filename: "sample.jpg",
            messageUUID: "b67ce13e-79ff-4a34-d5a1-3f05e5f679cd",
            messageType: .direct,
            groupMessageUUID: "null",
            directConversationUUID: "c87df14f-8a00-5b45-e6b2-4g06f6g7a0de",
            groupConversationUUID: "null"
        )
        
        let payload = Payload(
            senderUUID: "e9e2faf4-31ee-495c-96b8-c2fd7b731aff",
            recipientUUID: "e09c58b3-f1b5-4f50-9d0d-18eae402a950",
            content: "Hello, how are you today?  just checking out for you",
            status: .sent,
            messageTag: .general,
            requestUUID: "a57bd12d-68ee-4935-c590-2f04d4f578ab",
            attachments: [attachment]
        )
        
        let messageEvent = MessageEvent(eventType: .directMessage, payload: payload)
        return messageEvent
    
    }
    
    
    func connectToWebSocket() {
        if let accessToken = KeychainHelper.getToken() {
            viewModel.connect(token: accessToken)
        } else {
            // Handle error, e.g., show an alert or redirect the user to a login screen
            print("Error: Failed to retrieve access token from keychain.")
        }
    }
    
}

#Preview {
    MessageView()
//    .preferredColorScheme(.dark)

}

