//
//  MessageViewModel.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import Foundation
import SwiftUI

class MessageViewModel: ObservableObject{
    private let webSocketClient = WSClient()
    private let httpClient = HTTPClient()
    
    
    @Published var messages = [Payload]()
    

    
    
    
    init() {
        webSocketClient.onMessageReceived = { [weak self] messageEvent in
            DispatchQueue.main.async {
                self?.handleMessageEvent(messageEvent)
            }
        }
        
        
    }
    
    func connect(token: String) {
        webSocketClient.connect(token: token)
    }
    
    func send(messageEvent: MessageEvent) {
        webSocketClient.send(event: messageEvent)
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
