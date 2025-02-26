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
    
}


