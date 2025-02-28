//
//  EmojiArtModel.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import Foundation

struct EmojiArtModel: Codable {
    var backGround: URL?
    var emojis = [Emoji]()
    
    private var uniqueEmojiID = 0
    
    func json() throws -> Data {
        let encoded = try JSONEncoder().encode(self)
        print("Encoded Data: \(encoded)")
        return encoded
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }
    
    init() {
        
    }
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiID += 1
        emojis.append(.init(
            id: uniqueEmojiID,
            string: emoji,
            position: position,
            size: size
        ))
    }
    
    mutating func selectEmoji(with emoji: Emoji) {
        if let index = emojis.firstIndex(where: { emoji.id == $0.id }) {
            emojis[index].isSelected.toggle()
        }
    }
    
    mutating func deselectAllEmojis() {
        emojis.forEach { emoji in
            if let index = emojis.firstIndex(where: { emoji.id == $0.id}) {
                emojis[index].isSelected = false
            }
        }
    }
    
    mutating func deleteEmoji(with emoji: Emoji) {
        if let index = emojis.firstIndex(of: emoji) {
            emojis.remove(at: index)
        }
    }
    
    func anyEmojiIsSelected(in emojis: [Emoji]) -> Bool {
        return emojis.contains(where: { $0.isSelected })
    }
    
    struct Emoji: Identifiable, Hashable, Codable {
        var id: Int
        
        let string: String
        var position: Position
        var size: Int
        
        var isSelected: Bool = false
        
        struct Position: Codable, Equatable, Hashable {
            var x: Int
            var y: Int
            
            static let zero: Position = .init(x: 0, y: 0)
        }
    }
}

