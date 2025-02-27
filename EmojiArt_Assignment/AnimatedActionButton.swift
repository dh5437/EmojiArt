//
//  AnimatedActionButton.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/27/25.
//

import SwiftUI

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let action: () -> Void
    
    init(title: String? = nil, systemImage: String? = nil, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    var body: some View {
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
                    .font(.system(size: 40))
            } else if let title {
                Text(title)
                    .font(.system(size: 40))
            } else if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 40))
            }
        }
    }
}
