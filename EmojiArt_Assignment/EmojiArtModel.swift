//
//  EmojiArtModel.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import Foundation

struct EmojiArtModel {
    var backGround: URL?
    var emojis = [Emoji]()
    
    private var uniqueEmojiID = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiID += 1
        emojis.append(.init(
            id: uniqueEmojiID,
            string: emoji,
            position: position,
            size: size
        ))
    }
    
    struct Emoji: Identifiable, Hashable {
        var id: Int
        
        let string: String
        var position: Position
        var size: Int
        
        struct Position: Codable, Equatable, Hashable {
            var x: Int
            var y: Int
            
            static let zero: Position = .init(x: 0, y: 0)
        }
    }
}

