//
//  MessageView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var viewModel: MessageViewModel
    @State var messageText = ""
    let loggedInUser : User
    let recipient : String
    
    init(loggedInUser: User, recipient: String) {
        self.loggedInUser = loggedInUser
        self.recipient = recipient
        self._viewModel = StateObject(wrappedValue: MessageViewModel(recipientUUID: recipient, senderUUID: loggedInUser.uuid))
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                messageListView
                Divider()
                
                chatInputView
            }
            Divider()
            //            .background(Color(.systemGroupedBackground))
                .background(Color(.init(white: 0.95, alpha: 1)))
                .navigationTitle(recipient)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
//    private var messageListView: some View{
//        
//        ScrollViewReader  { proxy in
//            
//            ScrollView{
//                ForEach(viewModel.messages) { message in
//                    //change this
//                    let isCurrentUser = message.senderUUID == loggedInUser.uuid
//                    if isCurrentUser {
//                        HStack{
//                            Spacer()
//                          
//                        }
//                        .padding(.horizontal)
//                        .padding(.top, 8)
//                    }
//                    else{
//                        HStack{
//                            ZStack(alignment: .bottomTrailing) {
//                                HStack {
//                                    Text(message.content)
//                                        .padding(.vertical, 8)
//                                        .foregroundColor(.primary)
//                                }
//                                .padding()
//                                .background(Color(.systemGray6))
//                                .clipShape(ChatBubble(isCurrentUser:  isCurrentUser))
//                                
//                            Text("16:36")
//                                .font(.caption)
//                                .foregroundColor(.primary)
//                                .padding(.trailing, 8)
//                                .padding(.bottom, 8)
//                            
//                            }
//                            Spacer()
//                        }
//                        .padding(.horizontal)
//                        .padding(.top, 8)
//                        
//  
//                    }
//                    
//                }
//                
//                HStack{Spacer()}
//            }
//            
//        }
//
//    }
    private var messageListView: some View {
          ScrollView {
              ScrollViewReader { proxy in
                  VStack {
                      ForEach(viewModel.messages) { message in
                          messageRow(for: message)
                      }
                  }
                  .onChange(of: viewModel.messages, initial: true) { lastmessage, newValue in
                      if let lastMessage = newValue.last {
                          withAnimation {
                              proxy.scrollTo(lastMessage.id, anchor: .bottom)
                              
                          }
                      }
                  }
                  .onAppear {
                      if let lastMessage = viewModel.messages.last {
                          withAnimation {
                              proxy.scrollTo(lastMessage.id, anchor: .bottom)
                          }
                      }
                  }
              }
          }
      }
    
    private func messageRow(for message: Message) -> some View {
            let isCurrentUser = message.senderUUID == loggedInUser.uuid
            return Group {
                if isCurrentUser {
                    HStack{
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                           
                            HStack {
                                
                                Text(message.content)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .padding(.bottom, 8)
                            .background(Color(.systemBlue))
                            .clipShape(ChatBubble(isCurrentUser:  isCurrentUser))
                           
                            
                            HStack(spacing: 4) {
                                Text("16:36")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Image(systemName: imageName(for: message.status))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 12, height: 12)
                                    .clipShape(Circle())
                                 
                                .foregroundColor(.white)
                            }
                            .padding(.trailing, 8)
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                else{
                    HStack{
                        ZStack(alignment: .bottomTrailing) {
                            HStack {
                                Text(message.content)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(ChatBubble(isCurrentUser:  isCurrentUser))
                            
                        Text("16:36")
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.trailing, 8)
                            .padding(.bottom, 8)
                        
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
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
            
            TextField("Message...", text: $messageText)
                .padding(12)
                .background(Color(.systemGray4))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Button(action: {
                let messageEvent = sendMessage(senderUUID: loggedInUser.uuid, recipientUUID: recipient)
                viewModel.send(messageEvent: messageEvent)

                messageText = ""
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
    
    func sendMessage(senderUUID: String, recipientUUID: String) -> MessageEvent {
        let attachment = Attachment(
              attachmentUUID: nil, // Set to nil
              fileURL: "wellprobe360/wellprobe360-profile-image-upload-folder/ac41039d-add0-43ca-bb2b-88cfc7fea9f4.jpeg",
              fileSize: 1024,
              fileType: "image/jpeg",
              filename: "sample.jpg",
              messageType: "Direct",
              messageUUID: nil, // Generate a new UUID for the message
              groupMessageUUID: nil, // Set to nil
              directConversationUUID: nil, // Set to nil
              groupConversationUUID: nil, // Set to nil
              createdAt: nil, // Set to nil
              updatedAt: nil // Set to nil
          )
          
//          let payload = Message(
//            
//          )
        let payload = Payload.message(Message(
            uuid: nil, // Set to nil
            directConversationUUID: nil, // Set to nil
            senderUUID: senderUUID, // Use the passed senderUUID
            recipientUUID: recipientUUID, // Use the passed recipientUUID
            content: messageText, // Use the passed content
            clientUUID: UUID().uuidString, // Generate a new UUID for the client
            status: .sent,
            messageTag: .general,
            requestUUID: nil, // Set to nil
            attachments: [attachment],
            timestamp: nil, // Set to nil
            createdAt: nil, // Set to nil
            updatedAt: nil // Set to nil
           //... existing parameters remain the same
        ))
        
        let messageEvent = MessageEvent(eventType: .directMessage, payload: payload)
        return messageEvent
        
    }
    
    private func imageName(for status: MessageStatus) -> String {
        switch status {
        case .sent:
            return "clock"
        case .received:
            print("Checkmarl returned")
            return "checkmark"
        case .delivered:
            return "checkmark.circle"
        case .read:
            return "checkmark.circle.fill"
        default:
            return "clock" // Default case, you can adjust this as needed
        }
    }
    
}
//
//#Preview {
//    MessageView(loggedInUser: nil, recipient: nil)
////    .preferredColorScheme(.dark)
//
//}
//                    ForEach(message.attachments, id: \.fileURL) { attachment in
//                                // render the attachment based on its type.
//                                if attachment.fileType == "image/jpeg" {
//                                    // Assuming you have a way to load the image from the fileURL
//                                    Image(/* Load Image from attachment.fileURL */)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .cornerRadius(8)
//                                } else {
//                                    // Handle other attachment types.
//                                    Text("Attachment: \(attachment.filename)")
//                                }
//                            }
