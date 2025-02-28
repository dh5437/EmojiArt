//
//  PaletteStore.swift
//  EmojiArt_Assignment
//
//  Created by 김도현 on 2/27/25.
//

import SwiftUI

extension UserDefaults {
    func palettes(forKey key: String) -> [Palette] {
        if let jsondata = data(forKey: key), let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsondata) {
            return decodedPalettes
        } else {
            return []
        }
    }
    
    func set(_ palettes: [Palette], forKey key: String) {
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
}

class PaletteStore: ObservableObject {
    let name: String
    
    private var userDefaultsKey: String {
        "PaletteStore:" + name
    }
    
    var palettes: [Palette] {
        get {
            UserDefaults.standard.palettes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        if palettes.isEmpty {
            palettes = Palette.builtins
            if palettes.isEmpty {
                palettes = [Palette(name: "Warning", emojis: "⁉️⚠️")]
            }
        }
    }
    
    @Published private var _cursorIndex: Int = 0
    
    var cursorIndex: Int {
        get { boundsCheck(_cursorIndex) }
        set {
            _cursorIndex = boundsCheck(newValue)
        }
    }
    
    private func boundsCheck(_ index: Int) -> Int {
        var index = index % palettes.count
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) {
        let insertionIndex = boundsCheck(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id}) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
    }
    
    func append(_ palette: Palette) { // at end of palettes
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
    func append(name: String, emojis: String) {
        append(Palette(name: name, emojis: emojis))
    }
}
