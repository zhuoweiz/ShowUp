//
//  ReactionBubble.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct SimpleReactionBubble: View {
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.systemGray5))
                .frame(height:30)
        }
    }
}

struct ReactionBubble_Previews: PreviewProvider {
    static var previews: some View {
//        SimpleReactionBubble()
        EmptyView()
    }
}
