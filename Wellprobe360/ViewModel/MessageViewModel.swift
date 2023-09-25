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
    @Published var messages = [Payload]()
    var recipientUUID: String
    private let httpClient = HTTPClient()
    private var cancellables: Set<AnyCancellable> = []
    @EnvironmentObject var authViewModel: AuthViewModel
         
         
       
    init(recipientUUID: String) {
           self.recipientUUID = recipientUUID
           self.messages = GlobalWebSocketManager.shared.messagesDictionary[recipientUUID] ?? []
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
                   if messageEvent.payload.recipientUUID == self?.recipientUUID || messageEvent.payload.senderUUID == self?.recipientUUID  {
                       self?.handleMessageEvent(messageEvent)
                   }
               }
               .store(in: &cancellables)
       }
    
    
    func send(messageEvent: MessageEvent) {
          // Construct the MessageEvent object
//          let messageEvent = //... Your logic to create MessageEvent
          GlobalWebSocketManager.shared.send(event: messageEvent)
          // Optimistically append the message
//          messages.append(messageEvent.payload)
      }
    
    private func handleMessageEvent(_ messageEvent: MessageEvent) {
        print("Message event received in Viewmodel")
        
        switch messageEvent.eventType {
        case .directMessage:
            // Handle direct message
            print("Received a direct message!")
            print("Message: \(messageEvent)")
            messages.append(messageEvent.payload)
        case .directMessageReceived:
            
            if let index = messages.firstIndex(where: { $0.clientUUID == messageEvent.payload.clientUUID }) {
                // Replace the existing message with the one received from the server
                messages[index] = messageEvent.payload
                print("Index found and replaced: \(index)")
            }
            // Handle direct message received acknowledgment
            print("Received an acknowledgment for direct message!")
            // Add cases for other event types as needed
        default:
            break
        }
        // After handling the message, update the latestMessageEvent property
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
