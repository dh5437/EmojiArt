//
//  EmojiArtModel_Tests.swift
//  EmojiArt_AssignmentTests
//
//  Created by 김도현 on 2/26/25.
//

import Testing
@testable import EmojiArt_Assignment

struct EmojiArtModel_Tests {
    typealias Emoji = EmojiArtModel.Emoji
    var model = EmojiArtModel()
    private let emojis = "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"
    
    @MainActor
    @Test func test_EmojiArtModel_init_shouldHaveEmptyEmojis() async throws {
        // Given
        
        // When
        let emojis = model.emojis
        
        // Then
        #expect(emojis.isEmpty)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_addEmoji_shouldAddEmojiToEmojis() async throws {
        // Given
        // When
        model.addEmoji("😄", at: Emoji.Position(x: 0, y: 0), size: 10)
        
        // Then
        #expect(model.emojis.count == 1)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_addEmoji_shouldAddEmojiToEmojis_stress() async throws {
        // Given
        let randomCount = Int.random(in: 0..<1000)
        // When
        for _ in 0..<randomCount {
            model.addEmoji(emojis.map { String($0) }.randomElement()!,
                           at: Emoji.Position(
                            x: Int.random(in: -1000..<1000),
                            y: Int.random(in: -1000..<1000)
                           ),
                           size: Int.random(in: 0..<30)
            )
        }
        
        // Then
        #expect(model.emojis.count == randomCount)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_selectEmoji_shouldSelectEmoji() async throws {
        // Given
        model.addEmoji("😄", at: Emoji.Position(x: 0, y: 0), size: 10)
        
        // When
        model.selectEmoji(with: model.emojis[0])
        
        // Then
        #expect(model.emojis[0].isSelected)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_selectEmoji_shouldDeselectEmoji() async throws {
        // Given
        model.addEmoji("😄", at: Emoji.Position(x: 0, y: 0), size: 10)
        
        // When
        model.selectEmoji(with: model.emojis[0])
        #expect(model.emojis[0].isSelected)
        model.selectEmoji(with: model.emojis[0])
        
        // Then
        #expect(!model.emojis[0].isSelected)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_deselectAllEmoji_shouldDeselectAllEmoji() async throws {
        // Given
        model.addEmoji("😄", at: Emoji.Position(x: 0, y: 0), size: 10)
        model.addEmoji("❤️", at: Emoji.Position(x: 1, y: 1), size: 10)
        // When
        #expect(model.emojis.count == 2)
        
        model.selectEmoji(with: model.emojis[0])
        model.selectEmoji(with: model.emojis[1])
        #expect(model.emojis[0].isSelected)
        #expect(model.emojis[1].isSelected)
        model.deselectAllEmojis()
        // Then
        #expect(!model.emojis[0].isSelected)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_deselectAllEmoji_shouldDeselectAllEmoji_stress() async throws {
        // Given
        let randomCount = Int.random(in: 10...100)
        // When
        for _ in 0..<randomCount {
            model.addEmoji(
                "😄",
                at: Emoji.Position(
                    x: Int.random(in: -100...100),
                    y: Int.random(in: -100...100)
                ),
                size: 10)
            model.selectEmoji(with: model.emojis.last!)
        }
        #expect(model.emojis.count == randomCount)
        #expect(model.emojis.allSatisfy({ emoji in
            emoji.isSelected == true
        }))
        
        model.deselectAllEmojis()
        // Then
        #expect(model.emojis.allSatisfy({ emoji in
            emoji.isSelected == false
        }))
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_deleteEmoji_shouldDeleteEmoji() async throws {
        // Given
        model.addEmoji("😄", at: Emoji.Position(x: 0, y: 0), size: 10)
        
        // When
        #expect(model.emojis.count == 1)
        
        model.deleteEmoji(with: model.emojis[0])
        
        // Then
        #expect(model.emojis.isEmpty)
    }
    
    @MainActor
    @Test mutating func test_EmojiArtModel_deleteEmoji_shouldDeleteEmoji_stress() async throws {
        // Given
        let randomCount = Int.random(in: 0..<1000)
        // When
        for _ in 0..<randomCount {
            model.addEmoji(emojis.map { String($0) }.randomElement()!,
                           at: Emoji.Position(
                            x: Int.random(in: -1000..<1000),
                            y: Int.random(in: -1000..<1000)
                           ),
                           size: Int.random(in: 0..<30)
            )
        }
        #expect(model.emojis.count == randomCount)
        
        for _ in 0..<randomCount {
            if let randomEmoji = model.emojis.randomElement() {
                model.deleteEmoji(with: randomEmoji)
            }
        }
        
        // Then
        #expect(model.emojis.isEmpty)
    }
}


