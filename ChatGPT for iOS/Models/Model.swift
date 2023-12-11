//
//  Model.swift
//  ChatGPT for iOS
//
//  Created by JAESOON on 12/11/23.
//

import SwiftUI

enum MessageSender {
    case me
    case gpt
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From me", dateCreated: Date(), sender: .gpt)
    ]
}



