//
//  WebSocketClient.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import Foundation
import Starscream

class WSClient: WebSocketDelegate {
  
    
    private var socket: WebSocket?
    var onMessageReceived: ((MessageEvent) -> Void)?
    
    init() {
        // Initialization of the websocket will be done when connecting
    }

    func connect(token: String) {
        let request = URLRequest(url: URL(string: "ws://192.168.1.22:8000/ws?token=\(token)")!)
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
        case .disconnected(let reason, let code):
            print("Disconnected with reason: \(reason) and code: \(code)")
        case .text(let string):
            do {
                if let data = string.data(using: .utf8) {
                    let jsonString = String(data: data, encoding: .utf8) ?? ""
                    print("Received JSON string: \(jsonString)") //
                    
                    let messageEvent = try JSONDecoder().decode(MessageEvent.self, from: data)
                    onMessageReceived?(messageEvent)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        case .binary(let data):
            if let messageEvent = try? JSONDecoder().decode(MessageEvent.self, from: data) {
                onMessageReceived?(messageEvent)
                print("Received data: \(messageEvent)")
            
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


