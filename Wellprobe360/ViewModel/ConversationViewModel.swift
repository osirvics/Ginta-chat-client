//
//  ConversationViewModel.swift
//  Wellprobe360
//
//  Created by Victor Edu on 24/09/2023.
//

import Foundation
import SwiftUI
import Combine




class ConversationViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    let httpClient = HTTPClient()
    @Published var directConversations = [Conversation]()
    
    init() {
        getConversations()
        subscribeToIncomingMessages()
    }
    
    func getConversations() {
        httpClient.getAllConversations { result in
            switch result {
            case .success(let conversationResponse):
                print("Total Conversations: \(conversationResponse.directConversations.count)")
                self.directConversations = conversationResponse.directConversations
            case .failure(let error):
                print("Error fetching all conversations: \(error)")
            }
        }
    }
    
    func updateConversations() {
        httpClient.getAllConversations { result in
            switch result {
            case .success(let conversationResponse):
                self.directConversations.removeAll()
                self.directConversations = conversationResponse.directConversations
            case .failure(let error):
                print("Error fetching all conversations: \(error)")
            }
        }
    }
    
    private func subscribeToIncomingMessages() {
        GlobalWebSocketManager.shared.incomingMessages
            .sink { [weak self] messageEvent in
                switch messageEvent.payload {
                case .directConversation(_):
                    self?.handleUpdatedConversation(messageEvent)
                case .message(_):
                    // Handle or ignore Message objects based on your requirement.
                    print("Received a message payload")
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleUpdatedConversation(_ messageEvent: MessageEvent) {
        print("DEBUG: Received messageEvent in ConversationViewModel: \(messageEvent)")
        switch messageEvent.eventType {
        case .conversationUpdated:
            if case .directConversation(let directConversation) = messageEvent.payload {
                print("DEBUG: Received directConversation: \(directConversation)")
                
                // Find the conversation corresponding to the directConversation and update it
                if let index = directConversations.firstIndex(where: { $0.id == directConversation.id }) {
                    // Update the lastMessage and lastMessageAt of the conversation
                    directConversations[index].lastMessage = directConversation.lastMessage
                    directConversations[index].lastMessageAt = directConversation.lastMessageAt
//                    print("DEBUG: Updated conversation: \(directConversations[index])")
                } else {
                    // If the conversation does not exist in the list, add it.
                    updateConversations()
                    
                }
            }
        default:
            // Handle other eventTypes if needed
            print("Received unhandled eventType: \(messageEvent.eventType)")
        }
    }
}
