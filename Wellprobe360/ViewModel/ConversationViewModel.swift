//
//  ConversationViewModel.swift
//  Wellprobe360
//
//  Created by Victor Edu on 24/09/2023.
//

import Foundation
import SwiftUI

class ConversationViewModel: ObservableObject {
    let httpClient = HTTPClient()
    @Published var directConversations = [Conversation]()
    
    init() {
        getConversations()
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

}
