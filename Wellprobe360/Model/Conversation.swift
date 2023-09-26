//
//  Conversation.swift
//  Wellprobe360
//
//  Created by Victor Edu on 24/09/2023.
//

import Foundation


// MARK: - Welcome
struct ConversationResponse: Codable {
    let directConversations: [DirectConversation]

    enum CodingKeys: String, CodingKey {
        case directConversations = "direct_conversations"
    }
}

{
  "event_type": "conversation_updated",
  "payload": {
    "direct_conversation_uuid": "9db9ad7d-75f9-42c1-86c6-f1c6a0333377",
    "participant1_uuid": "e9e2faf4-31ee-495c-96b8-c2fd7b731aff",
    "participant2_uuid": "e09c58b3-f1b5-4f50-9d0d-18eae402a950",
    "last_message": "I don tire o",
    "last_message_at": "2023-09-26T21:16:14.619827",
    "created_at": "2023-09-25T17:12:56.284996",
    "updated_at": "2023-09-26T21:16:14.619827"
  }
}

// MARK: - DirectConversation
struct DirectConversation: Codable, Identifiable {
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
