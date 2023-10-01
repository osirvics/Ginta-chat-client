//
//  WebSocketClient.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import Foundation
import Starscream

class WSClient: WebSocketDelegate {
    private var reconnectAttempts = 0
    private var maxReconnectAttempts = 5 // or whatever limit you want to set
    private var token: String?
    var isConnected: Bool = false
    
    var socket: WebSocket?
    var onMessageReceived: ((MessageEvent) -> Void)?
    
    init() {
        // Initialization of the websocket will be done when connecting
    }

    func connect(token: String) {
        self.token = token
        let request = URLRequest(url: URL(string: "wss://wells--wellprobe360--slmzgs44xxyz.code.run/ws?token=\(token)")!)
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func send(event: MessageEvent) {
        do {
              let data = try JSONEncoder().encode(event)
              if let jsonString = String(data: data, encoding: .utf8) {
                  socket?.write(string: jsonString) // Sending JSON as String
              }
          } catch {
              print("Encoding failed with error: \(error)")
          }
    }

    func disconnect() {
        socket?.disconnect()
    }

   
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        print ("didReceive event fired")

        switch event {
        case .connected(let headers):
            print("Connected with headers: \(headers)")
            isConnected = true
            reconnectAttempts = 0 // reset the reconnectAttempts counter upon successful connection
        case .disconnected(let reason, let code):
            isConnected = false
            print("Disconnected with reason: \(reason) and code: \(code)")
            if reconnectAttempts < maxReconnectAttempts {
                            let delay = pow(2.0, Double(reconnectAttempts)) // Exponential backoff delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                if let token = self.token {
                                    self.connect(token: token)
                                    self.reconnectAttempts += 1
                                }
                            }
                        }
            
//            if reconnectAttempts < maxReconnectAttempts {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 seconds delay
//                                if let token = self.token {
//                                    self.connect(token: token)
//                                    self.reconnectAttempts += 1
//                                }
//                            }
//                        }
            
        case .text(let string):
            do {
                    if let data = string.data(using: .utf8) {
                        let jsonString = String(data: data, encoding: .utf8) ?? ""
//                        print("DEBUG: Received JSON string: \(jsonString)") //
                        
                        let messageEvent = try JSONDecoder().decode(MessageEvent.self, from: data)
                    
                        
                        switch messageEvent.payload {
                                       case .message(let message):
                                        break
//                                           print("DEBUG: Received message payload")
                                       case .directConversation(let directConversation):
//                                           print("DEBUG: Received DirectConversation payload")
                                                break
                        case .directMessageDelivery(_):
                            break
                                       
                        case .directMessageRead(_):
                            break
                        case .directMessageReadList(_):
                            break
                        }
                
                        
                        onMessageReceived?(messageEvent)
                    }
                } catch {
                    print("Decoding error: \(error)")
                }

        case .binary(let data):
            if let messageEvent = try? JSONDecoder().decode(MessageEvent.self, from: data) {
                onMessageReceived?(messageEvent)
//                print("Received data: \(messageEvent)")
            
            }
        case .ping(_):
            print("Ping received")
            
            break
        case .pong(_):
            print("Pong received")
            
            break
        case .viabilityChanged(_):
            print("Viability changed")
            break
        case .reconnectSuggested(_):
            print("Reconnect suggested")
            
            break
        case .cancelled:
            break
        case .error(let error):
            print("Error: \(String(describing: error))")
        case .peerClosed:
            print("Peer closed due to error")
            break
        }
    }
}


