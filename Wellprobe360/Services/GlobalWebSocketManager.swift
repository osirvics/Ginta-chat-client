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
//    @Published var incomingMessages: [MessageEvent] = []
    private(set) var incomingMessages = PassthroughSubject<MessageEvent, Never>()
    
    @Published var messagesDictionary: [String: [Payload]] = [:]
    private var webSocketClient = WSClient()
    
    
    
    

//    private init() {
//        webSocketClient.onMessageReceived = { [weak self] messageEvent in
//            DispatchQueue.main.async {
//                self?.incomingMessages.append(messageEvent)
//                // Here, you can handle global events, if any.
//            }
//        }
//    }
    
//    private init() {
//          webSocketClient.onMessageReceived = { [weak self] messageEvent in
//              DispatchQueue.main.async {
//                  print("Message received in GlobalWebSocketManager: \(messageEvent)")
//                  self?.incomingMessages.send(messageEvent)
//                  // ...
//              }
//          }
//      }
    
    
    private init() {
           webSocketClient.onMessageReceived = { [weak self] messageEvent in
               DispatchQueue.main.async {
                   // Store the message in messagesDictionary
                   let recipientUUID = messageEvent.payload.recipientUUID
                   var messages = self?.messagesDictionary[recipientUUID] ?? []
                   messages.append(messageEvent.payload)
                   self?.messagesDictionary[recipientUUID] = messages
                   self?.incomingMessages.send(messageEvent)
               }
           }
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

