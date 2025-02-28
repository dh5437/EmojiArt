//
//  PaletteStore_Tests.swift
//  EmojiArt_AssignmentTests
//
//  Created by 김도현 on 2/28/25.
//

import Testing
@testable import EmojiArt_Assignment

struct PaletteStore_Tests {
    let paletteStore = PaletteStore(named: "Test")
    
    @Test func test_PaletteStore_init_shouldLoadPalette() {
        #expect(paletteStore.palettes.count > 0)
    }
    
    @Test func test_PaletteStore_insert_shouldAddNewPalette() {
        // Given
        let palettesBeforeInsertion = paletteStore.palettes
        // When
        paletteStore.insert(Palette(name: "Test1", emojis: "😀😃"), at: 0)
        
        // Then
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes[0].name == "Test1")
        #expect(paletteStore.palettes[0].emojis == "😀😃")
    }
    
    @Test func test_PaletteStore_insert_shouldReplaceNewPalette() {
        // Given
        let palettesBeforeInsertion = paletteStore.palettes
        let testPalette = Palette(name: "Test1", emojis: "😀😃")
        // When
        paletteStore.insert(testPalette, at: 0)
        
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes[0].name == "Test1")
        #expect(paletteStore.palettes[0].emojis == "😀😃")
        
        paletteStore.insert(testPalette, at: 2)
        
        // Then
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes[0].name != "Test1")
        #expect(paletteStore.palettes[0].emojis != "😀😃")
    }
    
    @Test func test_PaletteStore_append_shouldAppendNewPaletteToLast() {
        // Given
        let palettesBeforeInsertion = paletteStore.palettes
        // When
        paletteStore.append(Palette(name: "Test1", emojis: "😀😃"))
        
        // Then
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes.last!.name == "Test1")
        #expect(paletteStore.palettes.last!.emojis == "😀😃")
    }
    
    @Test func test_PaletteStore_append_shouldReplacePaletteToLast() {
        // Given
        let palettesBeforeInsertion = paletteStore.palettes
        var testPalette = Palette(name: "Test1", emojis: "😀😃")
        // When
        paletteStore.insert(testPalette, at: 0)
        
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes[0].name == "Test1")
        #expect(paletteStore.palettes[0].emojis == "😀😃")
        
        testPalette.emojis = "🦁🐯🐱"
        paletteStore.append(testPalette)
        
        // Then
        #expect(paletteStore.palettes.count == palettesBeforeInsertion.count + 1)
        #expect(paletteStore.palettes.last!.name == "Test1")
        #expect(paletteStore.palettes.last!.emojis == "🦁🐯🐱")
    }
}
