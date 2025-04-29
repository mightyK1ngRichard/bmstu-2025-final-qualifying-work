//
//  CakeColor.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import ColorThiefSwift

struct CakeColor: View {
    @State var colors: [UIColor] = []
    @State var dominantColor: UIColor?
    var body: some View {
        VStack {
            if let dominantColor {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: dominantColor))
                    .frame(width: 100, height: 100)
            }

            Image(.categ1)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.hashValue) { uiColor in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(uiColor: uiColor))
                            .frame(width: 30, height: 30)
                    }
                }
            }

            Button {
//                let uiImage = UIImage(resource: .cake1)
//                if let dominantColor = ColorThief.getColor(from: uiImage) {
//                    print("Dominant color: \(dominantColor.makeUIColor().toHexString())")
//                    self.dominantColor = dominantColor.makeUIColor()
//                }
                
//                if let palette = ColorThief.getPalette(from: uiImage, colorCount: 5) {
//                    for color in palette {
//                        print("Palette color: \(color.makeUIColor())")
//                        colors.append(color.makeUIColor())
//                    }
//                }
            } label: {
                Text("Analyze Image")
            }
        }
    }
}

#Preview {
    CakeColor()
}
