//
//  EmojiArtViewModel.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import SwiftUI

class EmojiArtViewModel: ObservableObject {
    typealias Emoji = EmojiArtModel.Emoji
    @Published private var emojiArt = EmojiArtModel()
    
    var background: URL? {
        return emojiArt.backGround
    }
    
    var emojis: [Emoji] {
        return emojiArt.emojis
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.backGround = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        emojiArt.addEmoji(emoji, at: position, size: size)
    }
}
