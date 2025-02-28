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
    
    @EnvironmentObject var paletteStore: PaletteStore
    
    private let paletteSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .environmentObject(paletteStore)
        }
        .ignoresSafeArea()
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                documentContents(in: geometry)
                    .scaleEffect(zoomScale * gestureZoom)
                    .offset(position + gesturePosition)
            }
            .gesture(emojiArtViewModel.anyEmojiIsSelected(in: emojiArtViewModel.emojis) ? nil : dragGesture.simultaneously(with: zoomGesture))
            .onTapGesture {
                withAnimation(.spring()) {
                    emojiArtViewModel.deselectAllEmojis()
                }
            }
            .dropDestination(for: Sturldata.self) { sturlDatas, location in
                return drop(sturlDatas, at: location, in: geometry)
            }
        }
    }
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: emojiArtViewModel.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(emojiArtViewModel.emojis, id: \.self) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .border(Color.yellow, width: emoji.isSelected ? 2 : 0)
                .position(emoji.position.in(geometry))
                .gesture(emoji.isSelected ? dragGesture.simultaneously(with: zoomGesture) : nil)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        emojiArtViewModel.selectEmoji(at: emoji)
                    }
                }
                .contextMenu(menuItems: {
                    AnimatedActionButton(title: "Delete", systemImage: "minus.circle", role: .destructive) {
                        emojiArtViewModel.deleteEmoji(at: emoji)
                    }
                })
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
                    size: Int(paletteSize / zoomScale)
                )
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
            x: Int((location.x - center.x - position.width) / zoomScale),
            y: Int(-(location.y - center.y - position.height) / zoomScale)
        )
    }
    
    @State private var zoomScale: CGFloat = 1
    @GestureState var gestureZoom: CGFloat = 1
    
    private var zoomGesture: some Gesture {
        MagnifyGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                gestureZoom = inMotionPinchScale.magnification
            }
            .onEnded { value in
                zoomScale *= value.magnification
            }
    }
    
    @State private var position: CGSize = .zero
    @GestureState private var gesturePosition: CGSize = .zero
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($gesturePosition) { value, gesturePosition, _ in
                gesturePosition = value.translation
            }
            .onEnded { value in
                position += value.translation
            }
    }
}

#Preview {
    EmojiArtView(emojiArtViewModel: EmojiArtViewModel())
        .environmentObject(PaletteStore(named: "Test"))
}
