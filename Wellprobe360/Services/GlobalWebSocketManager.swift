//
//  GlobalWebSocketManager.swift
//  Wellprobe360
//
//  Created by Victor Edu on 24/09/2023.
//

import Foundation
import SwiftUI
import Combine

class GlobalWebSocketManager: ObservableObject {
    static let shared = GlobalWebSocketManager()
    private var wasConnected = false
//    @Published var incomingMessages: [MessageEvent] = []
    private(set) var incomingMessages = PassthroughSubject<MessageEvent, Never>()
    
    @Published var messagesDictionary: [String: [Message]] = [:]
    var webSocketClient = WSClient()
    
    private init() {
        
        if let token = KeychainHelper.getToken() {
                   webSocketClient.connect(token: token)
               }
        
        webSocketClient.onMessageReceived = { [weak self] messageEvent in
            DispatchQueue.main.async {
                switch messageEvent.payload {
                case .message(let newMessage):
                    // Access properties of the message here
                    let senderUUID = newMessage.senderUUID
                    let recipientUUID = newMessage.recipientUUID
                    let conversationID = self?.getConversationID(senderUUID: senderUUID, recipientUUID: recipientUUID) ?? ""
                    
                    // Check if the message already exists in the messagesDictionary
                    var messages = self?.messagesDictionary[conversationID] ?? []
                    
                    if let existingIndex = messages.firstIndex(where: { $0.uuid == newMessage.uuid }) {
                        // Replace the existing message with the new one
                        messages[existingIndex] = newMessage
                    } else {
                        // Append the new message
                        messages.append(newMessage)
                    }
                    
                    self?.messagesDictionary[conversationID] = messages
                    
                    if messageEvent.eventType == .directMessage{
                        self?.sendDeliveryAcknowledgment(messageUUID: newMessage.uuid ?? "", senderUUID: newMessage.senderUUID, status: .delivered)
                    }
                    
                    
                case .directConversation(_):
                    // Handle DirectConversation Payload as per your requirement
                    break
                case .directMessageDelivery(_):
                    // Handle DirectMessageDelivery Payload as per your requirement
                    break
                case .directMessageRead(_):
                    break
                case .directMessageReadList(_):
                    break
                }
//                switch messageEvent.eventType {
//                case .directMessage( let message):
//                    self?.sendDeliveryAcknowledgment(messageUUID: message.uuid, senderUUID: message.senderUUID, status: .delivered)
//                }
                    
                
                self?.incomingMessages.send(messageEvent)
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
       }
    
    
    private func sendDeliveryAcknowledgment(messageUUID: String, senderUUID: String, status: MessageStatus){
        
        let deliveryPayload = Payload.directMessageDelivery(DirectMessageDelivery(
            uuid: messageUUID,
            senderUUID: senderUUID,
            status: status
        ))
        
        let messageEvent = MessageEvent(
            eventType: .directMessageDelivered,
            payload: deliveryPayload
        )
        send(event: messageEvent)
    }
    
    @objc private func appWillResignActive() {
            wasConnected = webSocketClient.isConnected
            webSocketClient.disconnect()
        }

        @objc private func appDidBecomeActive() {
            if wasConnected, let token = KeychainHelper.getToken() {
                webSocketClient.connect(token: token)
            }
        }
    
   
    
    func getConversationID(senderUUID: String, recipientUUID: String) -> String {
        let ids = [senderUUID, recipientUUID].sorted() // sort the UUIDs
        return ids.joined(separator: "_") // join the sorted UUIDs with an underscore
    }

    
    func connect(token: String) {
        webSocketClient.connect(token: token)
    }
    
    func send(event: MessageEvent) {
        webSocketClient.send(event: event)
    }
    
    func disconnect() {
        webSocketClient.disconnect()
    }
}

//        webSocketClient.onMessageReceived = { [weak self] messageEvent in
//               DispatchQueue.main.async {
//                   switch messageEvent.payload {
//                   case .message(let message):
//                       // Access properties of message here
//                       let senderUUID = message.senderUUID
//                       let recipientUUID = message.recipientUUID
//                       let conversationID = self?.getConversationID(senderUUID: senderUUID, recipientUUID: recipientUUID) ?? ""
//                       var messages = self?.messagesDictionary[conversationID] ?? []
//                       messages.append(message)
//                       self?.messagesDictionary[conversationID] = messages
//                   case .directConversation(let directConversation):
//                       break
////                            print("DEBUG: DirectConversation received in GlobalWebSocketManager \(directConversation)")
//                       // Handle DirectConversation Payload as per your requirement
//                   case .directMessageDelivery(_):
//                          // Handle DirectMessageDelivery Payload as per your requirement
//                          break
//                   }
//                   self?.incomingMessages.send(messageEvent)
//               }
//           }
