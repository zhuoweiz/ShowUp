//
//  FriendPostBlock.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import SwiftUI

struct FriendPostBlock: View {
    var habitID: String
    var post: Post
    
    @State private var isShowingReactionsView = false
    @State private var reactionCount = 0;
    
    @State private var dateText = ""

    var body: some View {
        Section {
            Text(post.title ?? "")
            
            if let uiimageData = post.image {
                Image(uiImage: uiimageData)
                    .resizable()
                    .cornerRadius(16)
                    .scaledToFit()
            } else {
            }
            
            HStack {
                Text("")
                Spacer()
//                Text("\(reactionCount)")
                Button("Reactions") {
                    self.isShowingReactionsView = true
                }
                NavigationLink(destination: FriendPostReactionView(postID: post.id ?? "", habitID: habitID), isActive: $isShowingReactionsView) { EmptyView() }
            }
        } header: {
            Text("Date: \(dateText)")
        }.onAppear() {
            let date = post.postDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            dateText = "\(dateFormatter.string(from: date ?? Date()))"
        }
    }
}

struct FriendPostBlock_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
