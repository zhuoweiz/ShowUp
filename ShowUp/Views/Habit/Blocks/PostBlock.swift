//
//  PostBlock.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct PostBlock: View {
    var post: Post
    var habitID: String
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
                Spacer()
//                Text("\(reactionCount)")
                Button("Reactions") {
                    self.isShowingReactionsView = true
                }
                NavigationLink(destination: UserPostReactionsView(postID: post.id!, habitID: habitID), isActive: $isShowingReactionsView) { EmptyView() }
            }
        } header: {
            Text("Date: \(dateText)")
        }
        .onAppear() {
            let date = post.postDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            dateText = "\(dateFormatter.string(from: date ?? Date()))"
        }
    }
}

struct PostBlock_Previews: PreviewProvider {
    static var previews: some View {
//        PostBlock()
        EmptyView()
    }
}
