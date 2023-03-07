//
//  DeveloperSection.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct DeveloperSection: View {
    var body: some View {
        Section {
            Text("Contact Developer")
            Text("User Terms & Agreement")
        } header: {
            Text("Developer")
        }
    }
}

struct DeveloperSection_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSection()
    }
}
