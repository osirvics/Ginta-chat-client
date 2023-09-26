//
//  Conversation.swift
//  Wellprobe360
//
//  Created by Victor Edu on 24/09/2023.
//

import Foundation


// MARK: - Welcome
struct ConversationResponse: Codable {
    let directConversations: [Conversation]

    enum CodingKeys: String, CodingKey {
        case directConversations = "direct_conversations"
    }
}


struct Conversation: Codable, Identifiable {
    var id: String {
        directConversationUUID
    }
    
    
    let directConversationUUID, participant1UUID, participant2UUID, lastMessage: String
    let lastMessageAt, createdAt,  participantFirstname: String
    let updatedAt : String?
    let participantLastname: String
    let participantProfilePicture: String?

    enum CodingKeys: String, CodingKey {
        case directConversationUUID = "direct_conversation_uuid"
        case participant1UUID = "participant1_uuid"
        case participant2UUID = "participant2_uuid"
        case lastMessage = "last_message"
        case lastMessageAt = "last_message_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case participantFirstname = "participant_firstname"
        case participantLastname = "participant_lastname"
        case participantProfilePicture = "participant_profile_picture"
    }
}

// MARK: - DirectConversation
struct DirectConversation: Codable, Identifiable {
    var id: String {
        directConversationUUID
    }
    
    
    let directConversationUUID, participant1UUID, participant2UUID, lastMessage: String
    let lastMessageAt, createdAt: String
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case directConversationUUID = "direct_conversation_uuid"
        case participant1UUID = "participant1_uuid"
        case participant2UUID = "participant2_uuid"
        case lastMessage = "last_message"
        case lastMessageAt = "last_message_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
