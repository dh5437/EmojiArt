//
//  PaletteChooser.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/27/25.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var paletteStore: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: paletteStore.palettes[paletteStore.cursorIndex])
        }
        .clipped()
        .padding(.horizontal)
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            withAnimation(.easeInOut) {
                paletteStore.cursorIndex += 1
            }
        }
        .contextMenu {
            AnimatedActionButton(title: "New", systemImage: "plus.circle") {
                paletteStore.insert(name: "Math", emojis: "✖️🟰➕➖➗♾️")
            }
            AnimatedActionButton(title: "Delete", systemImage: "trash", role: .destructive) {
                paletteStore.palettes.remove(at: paletteStore.cursorIndex)
            }
        }
    }
    
    private func view(for palette: Palette) -> some View {
        HStack(alignment: .center) {
            Text(palette.name)
                .font(.title)
            ScrollingEmojis(emojis: palette.emojis.map {String($0)})
        }
        .padding(.vertical, 10  )
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 40))
                        .draggable(emoji)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(named: "Test"))
}
