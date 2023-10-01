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
        getAllMessages(recipientUUID: recipientUUID)
    }
    
    private func subscribeToIncomingMessages() {
        GlobalWebSocketManager.shared.incomingMessages
            .sink { [weak self] messageEvent in
                switch messageEvent.payload {
                case .message(let message):
                    //                /*    if message.recipientUUID == self?.recipientUUID || message.senderUUID == self?.recipientUUID*/ {
                    self?.handleMessageEvent(messageEvent)
                    //                    print("DEBUG: message in sub \(MessageEvent.eventType)")
                    //                    }
                case .directConversation(_):
                    break
                case .directMessageDelivery(_):
                    break
                case .directMessageRead(_):
                    break
                case .directMessageReadList(let messageReadList):
                    
                    // Create a set of UUIDs to mark as read for O(1) lookup
                    let uuidsToMarkAsRead = Set(messageReadList.messageUuids)
                    // If self?.messages exists, proceed with the operation
                    if var messages = self?.messages {
                        for (index, message) in messages.enumerated() {
                            if let uuid = message.uuid, uuidsToMarkAsRead.contains(uuid) {
                                // Update the status to "Read" for that message
                                messages[index].status = .read
                            }
                        }
                        // Update the @Published var messages with the modified array
                        self?.messages = messages
                    }
                    
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    
    func send(messageEvent: MessageEvent) {
        GlobalWebSocketManager.shared.send(event: messageEvent)
        switch messageEvent.payload {
        case .message(let message):
            messages.append(message)
        case .directConversation(_):
            // Handle if you ever need to send a DirectConversation object
            break
        case .directMessageDelivery(_):
            break
        case .directMessageRead(_):
            break
        case .directMessageReadList(_):
            break
        }
    }
    
    private func handleMessageEvent(_ messageEvent: MessageEvent) {
//        print("DEBUG: Message event received in Viewmodel")
        
        switch messageEvent.eventType {
        case .directMessage, .directMessageReceived, .directMessageDelivered, .directMessageRead, .directMessageReadList:
            switch messageEvent.payload {
            case .message(let message):
                if messageEvent.eventType == .directMessage {
                    insertMessageSorted(message)
                    sendDeliveryAcknowledgment(messageUUID: message.uuid ?? "",
                                               senderUUID: message.senderUUID,
                                               status: .read
                    )
                
                } else if messageEvent.eventType == .directMessageReceived {
                    if let index = messages.firstIndex(where: { $0.clientUUID == message.clientUUID }) {
                        messages[index] = message
                        sortMessages()
                    }
                    
                } else if messageEvent.eventType == .directMessageDelivered {
                    if let index = messages.firstIndex(where: { $0.clientUUID == message.clientUUID }) {
                        messages[index] = message
                        sortMessages()
                    }
                }
                else if messageEvent.eventType == .directMessageRead {
                   if let index = messages.firstIndex(where: { $0.clientUUID == message.clientUUID }) {
                       messages[index] = message
                       sortMessages()
                   }
               }
                else if messageEvent.eventType == .directMessageReadList  {
               }
            case .directConversation(_):
                break
            case .directMessageDelivery(_):
                break
                
            case .directMessageRead(_):
                break
            case .directMessageReadList(let messageReadList):
                if messageEvent.eventType == .directMessageReadList {
                    print("WARNING: Received a message read list! \(messageReadList)")
                }
               
                
                break
            }
            // Add cases for other event types as needed
        case .conversationUpdated:
            // Handle the case when the payload is a DirectConversation.
            if case let .directConversation(directConversation) = messageEvent.payload {
                print("Received a conversation update!")
            }
        default:
            break
        }
        
    }
    
    private func sendDeliveryAcknowledgment(messageUUID: String, senderUUID: String, status: MessageStatus){
        
        let deliveryPayload = Payload.directMessageDelivery(DirectMessageDelivery(
            uuid: messageUUID,
            senderUUID: senderUUID,
            status: status
        ))
        
        let messageEvent = MessageEvent(
            eventType: .directMessageRead,
            payload: deliveryPayload
        )
        GlobalWebSocketManager.shared.send(event: messageEvent)
    }
    
    private func insertMessageSorted(_ message: Message) {
        if let timestamp = message.timestamp {
            // Searching for the position where the new message should be inserted
            if let index = messages.firstIndex(where: { $0.timestamp ?? Int64.max > timestamp }) {
                messages.insert(message, at: index)
            } else {
                // If no such message is found, append the new message at the end.
                messages.append(message)
            }
        } else {
            messages.append(message)
        }
    }
    private func sortMessages() {
        messages.sort(by: { $0.timestamp ?? Int64.min < $1.timestamp ?? Int64.min })
    }
    
    func getAllMessages(recipientUUID: String) {
        httpClient.getAllMessages(participantUUID: recipientUUID) { (result) in
            switch result {
            case .success(let response):
                // Iterate over each message in the response
                for incomingMessage in response.directMessages {
                    // Try to find an index of an existing message with the same clientUUID
                    if let index = self.messages.firstIndex(where: { $0.clientUUID == incomingMessage.clientUUID }) {
                        // Replace the existing message with the updated one
                        self.messages[index] = incomingMessage
                    } else {
                        // If the message doesn't exist, add it to the array
                        self.messages.append(incomingMessage)
                    }
                }
                // Sort the messages
                self.messages.sort(by: { $0.timestamp ?? Int64.min < $1.timestamp ?? Int64.min })
            case .failure(let error):
                print(error)
            }
        }
    }


    
}

//    func getAllMessages(recipientUUID: String) {
//        httpClient.getAllMessages(participantUUID: recipientUUID) { (result) in
//            switch result {
//            case .success(let response):
//                let uniqueMessages = response.directMessages.filter { incomingMessage in
//                    !self.messages.contains { $0.clientUUID == incomingMessage.clientUUID }
//                }
//                // Sort and merge the unique messages with the existing messages
//                self.messages = (self.messages + uniqueMessages)
//                    .sorted(by: { $0.timestamp ?? Int64.min < $1.timestamp ?? Int64.min })
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
