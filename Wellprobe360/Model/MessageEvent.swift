//
//  MessageEvent.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)


import Foundation
import SwiftUI

//// MARK: - MessageEvent
//struct MessageEvent: Codable {
//    let eventType: MessageEventType
//    let payload: Message
//    
//
//    enum CodingKeys: String, CodingKey {
//        case eventType = "event_type"
//        case payload
//    }
//}

struct MessageEvent: Codable {
    let eventType: MessageEventType
    let payload: Payload
    
    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case payload
    }
}


struct MessageResponse: Codable {
    let directMessages: [Message]

    enum CodingKeys: String, CodingKey {
        case directMessages = "direct_messages"
    }
}

// MARK: - Payload
struct Message: Codable, Identifiable {
    let uuid: String?
    let directConversationUUID: String?
    let senderUUID: String
    let recipientUUID: String
    let content: String
    let clientUUID: String
    let status: MessageStatus
    let messageTag: MessageTag
    let requestUUID: String?
    let attachments: [Attachment]
    let timestamp: Int64?
    let createdAt: String?
    let updatedAt: String?
    
    var id: String {
        return clientUUID // Use uuid or a new UUID if it's nil
    }

    enum CodingKeys: String, CodingKey {
        case uuid
        case senderUUID = "sender_uuid"
        case recipientUUID = "recipient_uuid"
        case content, status
        case clientUUID = "client_uuid"
        case messageTag = "message_tag"
        case requestUUID = "request_uuid"
        case directConversationUUID = "direct_conversation_uuid"
        case attachments
        case timestamp
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let attachmentUUID: String?
    let fileURL: String
    let fileSize: Int
    let fileType: String
    let filename: String
    let messageType: String
    let messageUUID: String?
    let groupMessageUUID: String?
    let directConversationUUID: String?
    let groupConversationUUID: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case attachmentUUID = "attachment_uuid"
        case fileURL = "file_url"
        case fileSize = "file_size"
        case fileType = "file_type"
        case filename
        case messageType = "message_type"
        case messageUUID = "message_uuid"
        case groupMessageUUID = "group_message_uuid"
        case directConversationUUID = "direct_conversation_uuid"
        case groupConversationUUID = "group_conversation_uuid"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// Enums...


enum MessageType: String, Codable {
    case direct = "Direct"
    case group = "Group"
   
}

enum MessageStatus: String, Codable {
    case sent = "Sent"
    case received = "Received"
    case delivered = "Delivered"
    case read = "Read"

}

enum MessageTag: String, Codable {
    case general = "General"
    case quote = "Quote"
}

enum MessageEventType: String, Codable {
    case directMessage = "direct_message"
    case directMessageReceived = "direct_message_received"
    case directMessageDelivered = "direct_message_delivered"
    case directMessageRead = "direct_message_read"
    case groupMessage = "group_message"
    case groupMessageReceived = "group_message_received"
    case conversationUpdated = "conversation_updated"

   
}


enum Payload: Codable {
    case message(Message)
    case directConversation(DirectConversation)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let message = try? container.decode(Message.self) {
            self = .message(message)
            return
        }
        if let directConversation = try? container.decode(DirectConversation.self) {
            self = .directConversation(directConversation)
            return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode payload")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .message(let message):
            try container.encode(message)
        case .directConversation(let directConversation):
            try container.encode(directConversation)
        }
    }
}


