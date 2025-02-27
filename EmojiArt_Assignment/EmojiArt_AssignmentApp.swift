//
//  EmojiArt_AssignmentApp.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import SwiftUI

@main
struct EmojiArt_AssignmentApp: App {
    @StateObject var emojiArtViewmodel = EmojiArtViewModel()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtView(emojiArtViewModel: emojiArtViewmodel)
                .environmentObject(paletteStore)
        }
    }
}
