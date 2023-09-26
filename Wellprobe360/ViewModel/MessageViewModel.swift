//
//  MessageViewModel.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import Foundation
import SwiftUI
import Combine



class MessageViewModel: ObservableObject{
    @Published var messages = [Message]()
    var recipientUUID: String
    var senderUUID: String
    private let httpClient = HTTPClient()
    private var cancellables: Set<AnyCancellable> = []
    @EnvironmentObject var authViewModel: AuthViewModel
         
         
       
    init(recipientUUID: String, senderUUID: String) {
           self.recipientUUID = recipientUUID
           self.senderUUID = senderUUID
              
           let conversationID = GlobalWebSocketManager.shared.getConversationID(
           senderUUID: senderUUID, recipientUUID: recipientUUID)
           
           self.messages = GlobalWebSocketManager.shared.messagesDictionary[conversationID] ?? []
           
           subscribeToIncomingMessages()
       }

//       private func subscribeToIncomingMessages() {
//           for message in GlobalWebSocketManager.shared.incomingMessages where message.payload.recipientUUID == recipientUUID {
//               handleMessageEvent(message)
//           }
//       }
    private func subscribeToIncomingMessages() {
        GlobalWebSocketManager.shared.incomingMessages
            .sink { [weak self] messageEvent in
                switch messageEvent.payload {
                case .message(let message):
                    if message.recipientUUID == self?.recipientUUID || message.senderUUID == self?.recipientUUID {
                        self?.handleMessageEvent(messageEvent)
                    }
                case .directConversation(_):
                    // Handle or ignore DirectConversation objects based on your requirement.
                    break
                }
            }
            .store(in: &cancellables)
    }
//    private func subscribeToIncomingMessages() {
//        
//           GlobalWebSocketManager.shared.incomingMessages
//               .sink { [weak self] messageEvent in
//                   /*if messageEvent.payload.recipientUUID == self?.recipientUUID || messageEvent.payload.senderUUID == self?.recipientUUID*/  /*{*/
//                       self?.handleMessageEvent(messageEvent)
////                   }
//               }
//               .store(in: &cancellables)
//       }
//    
    
//    func send(messageEvent: MessageEvent) {
//          // Construct the MessageEvent object
////          let messageEvent = //... Your logic to create MessageEvent
//          GlobalWebSocketManager.shared.send(event: messageEvent)
//          // Optimistically append the message
////          messages.append(messageEvent.payload)
//      }
    
    func send(messageEvent: MessageEvent) {
        GlobalWebSocketManager.shared.send(event: messageEvent)
        // Optimistically append the message
        switch messageEvent.payload {
        case .message(let message):
            messages.append(message)
        case .directConversation(_):
            // Handle if you ever need to send a DirectConversation object
            break
        }
    }
    
    private func handleMessageEvent(_ messageEvent: MessageEvent) {
        print("DEBUG: Message event received in Viewmodel")
          
          switch messageEvent.eventType {
          case .directMessage, .directMessageReceived:
              switch messageEvent.payload {
              case .message(let message):
                  if messageEvent.eventType == .directMessage {
                      // Handle direct message
                      print("DEBUG: Received a direct message!")
                      messages.append(message)
                  } else if messageEvent.eventType == .directMessageReceived {
                      // Handle direct message received acknowledgment
                      print("DEBUG: Received an acknowledgment for direct message!")
                      if let index = messages.firstIndex(where: { $0.clientUUID == message.clientUUID }) {
                          // Replace the existing message with the one received from the server
                          messages[index] = message
                          print("DEBUG: Index found and replaced: \(index)")
                      }
                  }
              case .directConversation(_):
                  // This shouldn't occur for these event types, but you can decide how you want to handle it.
                  break
              }
          // Add cases for other event types as needed
          case .conversationUpdated:
              // Handle the case when the payload is a DirectConversation.
              if case let .directConversation(directConversation) = messageEvent.payload {
                  print("Received a conversation update!")
                  // Perform the necessary operations with the received DirectConversation object.
              }
          default:
              break
          }
//        print("Message event received in Viewmodel")
//        
//        switch messageEvent.eventType {
//        case .directMessage:
//            // Handle direct message
//            print("Received a direct message!")
//            messages.append(messageEvent.payload)
//        case .directMessageReceived:
//            
//            if let index = messages.firstIndex(where: { $0.clientUUID == messageEvent.payload.clientUUID }) {
//                // Replace the existing message with the one received from the server
//                messages[index] = messageEvent.payload
//                print("Index found and replaced: \(index)")
//            }
//            // Handle direct message received acknowledgment
//            print("Received an acknowledgment for direct message!")
//            // Add cases for other event types as needed
//        default:
//            break
//        }
//        // After handling the message, update the latestMessageEvent property
    }
    
    func getAllMessages(recipientUUID: String){
        httpClient.getAllMessages(participantUUID: recipientUUID) { (result) in
            switch result{
            case .success(let response):
                self.messages.append(contentsOf: response.directMessages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//    func connect(token: String) {
//        webSocketClient.connect(token: token)
//    }
//
//    func send(messageEvent: MessageEvent) {
//        webSocketClient.send(event: messageEvent)
//    }
    
//    func sendMessage(content: String) {
//          // Construct the MessageEvent object
//          let messageEvent = //... Your logic to create MessageEvent
//          GlobalWebSocketManager.shared.send(event: messageEvent)
//          // Optimistically append the message
//          messages.append(messageEvent.payload)
//      }
