//
//  ChatBubble.swift
//  Wellprobe360
//
//  Created by Victor Edu on 20/09/2023.
//

import SwiftUI

import SwiftUI

struct ChatBubble: Shape {
    var isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight, isCurrentUser ? .bottomLeft : .bottomRight],
            cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

#Preview {
    ChatBubble(isCurrentUser: true)
}

