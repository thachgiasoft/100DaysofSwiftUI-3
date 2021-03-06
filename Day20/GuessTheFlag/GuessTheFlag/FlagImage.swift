//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by 曹琴 on 2020/1/9.
//  Copyright © 2020 csike. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    
    let name: String
    
    @State private var faded = false
    @State private var correctlyGuessed = false
    
    var body: some View {
        return Image(name)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init(.tertiarySystemBackground), lineWidth: 1))
            .shadow(color: .primary, radius: 5)
            .opacity(faded ? 0.2 : 1)
            .rotation3DEffect(correctlyGuessed ? .degrees(180) : .degrees(0), axis:(x:0, y: 1, z: 0))
            .animation(.default)
    }
    
    func setCorrectlyGuessed() {
        self.correctlyGuessed = true
    }
    
    func setFaded() {
        self.faded = true
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "Germany")
    }
}
