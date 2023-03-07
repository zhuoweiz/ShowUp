//
//  SearchFriendView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct SearchFriendView: View {
    @State private var searchText = ""
    @State private var searchResult: [String: String] = [:] // email : uid
    
    var body: some View {
        List {
            
        }
        .navigationTitle("Search Friends to Invite")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct SearchFriendView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendView()
    }
}
