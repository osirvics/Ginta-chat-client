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

import SwiftUI


// MARK: - Welcome
struct MessageEvent: Codable {
    let eventType: MessageEventType
    let payload: Payload

    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case payload
    }
}


// MARK: - Payload
struct Payload: Codable {
    let senderUUID, recipientUUID, content: String
    let status: MessageStatus
    let messageTag: MessageTag
    let requestUUID: String
    let attachments: [Attachment]

    enum CodingKeys: String, CodingKey {
        case senderUUID = "sender_uuid"
        case recipientUUID = "recipient_uuid"
        case content, status
        case messageTag = "message_tag"
        case requestUUID = "request_uuid"
        case attachments
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let fileURL: String
    let fileSize: Int
    let fileType, filename, messageUUID: String
    let messageType: MessageType
    let groupMessageUUID, directConversationUUID, groupConversationUUID: String

    enum CodingKeys: String, CodingKey {
        case fileURL = "file_url"
        case fileSize = "file_size"
        case fileType = "file_type"
        case filename
        case messageType = "message_type"
        case messageUUID = "message_uuid"
        case groupMessageUUID = "group_message_uuid"
        case directConversationUUID = "direct_conversation_uuid"
        case groupConversationUUID = "group_conversation_uuid"
    }
}

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
}

