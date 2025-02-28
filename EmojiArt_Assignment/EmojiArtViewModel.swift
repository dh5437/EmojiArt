//
//  EmojiArtViewModel.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import SwiftUI

class EmojiArtViewModel: ObservableObject {
    typealias Emoji = EmojiArtModel.Emoji
    @Published private var emojiArt = EmojiArtModel() {
        didSet {
            autosave()
        }
    }
    
    private let autoSavedPath: URL = URL.documentsDirectory.appendingPathComponent("autoSaved.emojiArt")
    
    private func autosave() {
        save(to: autoSavedPath)
        print("autoSaved: \(autoSavedPath)")
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    init() {
        if let data = try? Data(contentsOf: autoSavedPath), let autoSavedModel = try? EmojiArtModel(json: data) {
            emojiArt = autoSavedModel
        }
    }
    
    var background: URL? {
        return emojiArt.backGround
    }
    
    var emojis: [Emoji] {
        return emojiArt.emojis
    }
    
    func anyEmojiIsSelected(in emojis: [Emoji]) -> Bool {
        return emojiArt.anyEmojiIsSelected(in: emojis)
    }

    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.backGround = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        emojiArt.addEmoji(emoji, at: position, size: size)
    }
    
    func selectEmoji(at emoji: Emoji) {
        emojiArt.selectEmoji(with: emoji)
    }
    
    func deselectAllEmojis() {
        emojiArt.deselectAllEmojis()
    }
    
    func deleteEmoji(at emoji: Emoji) {
        emojiArt.deleteEmoji(with: emoji)
    }
}
