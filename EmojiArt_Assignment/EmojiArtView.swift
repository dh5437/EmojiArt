//
//  ContentView.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/26/25.
//

import Foundation
import SwiftUI

struct EmojiArtView: View {
    typealias Emoji = EmojiArtModel.Emoji
    @ObservedObject var emojiArtViewModel: EmojiArtViewModel
    
    private let emojis = "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"
    
    private let paletteSize: CGFloat = 48
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ScrollingEmojis(emojis: emojis.map { String($0) })
        }
        .ignoresSafeArea()
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: emojiArtViewModel.background)
                    .position(Emoji.Position.zero.in(geometry))
                ForEach(emojiArtViewModel.emojis, id: \.self) { emoji in
                    Text(emoji.string)
                        .font(.system(size: CGFloat(emoji.size)))
                        .position(emoji.position.in(geometry))
                }
            }
            .dropDestination(for: Sturldata.self) { sturlDatas, location in
                return drop(sturlDatas, at: location, in: geometry)
            }
        }
    }
    
    private func drop(_ sturlDatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturlData in sturlDatas {
            switch sturlData {
            case .url(let url):
                emojiArtViewModel.setBackground(url)
                return true
            case .string(let emoji):
                emojiArtViewModel.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: Int(paletteSize))
                return true
            default:
                break
            }
        }
        
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        
        return Emoji.Position(
            x: Int(location.x - center.x),
            y: Int(-(location.y - center.y))
        )
    }
}

extension EmojiArtModel.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 40))
                        .draggable(emoji)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

#Preview {
    EmojiArtView(emojiArtViewModel: EmojiArtViewModel())
}
