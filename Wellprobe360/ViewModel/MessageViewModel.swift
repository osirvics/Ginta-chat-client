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

     // A published property to hold the latest received message event
     @Published var latestMessageEvent: MessageEvent?

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
         
         case .directMessageReceived:
             // Handle direct message received acknowledgment
             print("Received an acknowledgment for direct message!")
         // Add cases for other event types as needed
         default:
             break
         }
         // After handling the message, update the latestMessageEvent property
         latestMessageEvent = messageEvent
     }
}
