//
//  EmojiArtViewModel_Tests.swift
//  EmojiArt_AssignmentTests
//
//  Created by 김도현 on 2/28/25.
//

import Testing
import Foundation
@testable import EmojiArt_Assignment

struct EmojiArtViewModel_Tests {
    let viewModel = EmojiArtViewModel()
    
    @Test func test_EmojiArtViewModel_setBackground_shouldChangeBackgound() async throws {
        // Given
        let mockURL = URL(string: "https://example.com/image.png")!
        // When
        let background = viewModel.background
        #expect(background == nil)
    
        viewModel.setBackground(mockURL)
        // Then
        #expect(viewModel.background == mockURL)
    }
    
    
}
