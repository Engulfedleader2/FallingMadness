//
//  HighScoreScene.swift
//  FallingMadness
//
//  Created by Israel on 8/8/24.
//

import SwiftUI

struct HighScoreScene: View {
    var body: some View {
            HStack{
                Rectangle()
                    .fill(.red)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 300, height: 300)
                HStack{
                    Text("High Score")
                        .padding(.top)
                }
            }
        
    }
}

#Preview {
    HighScoreScene()
}
