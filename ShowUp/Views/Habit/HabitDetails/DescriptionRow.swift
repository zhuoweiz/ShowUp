//
//  DescriptionRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct DescriptionRow: View {
    var desc: String
    var body: some View {
        HStack {
            Text("Descriptions: ")
                .bold()
            Spacer()
            Text("\(desc)")
            .foregroundColor(.secondary)
        }
    }
}

struct DescriptionRow_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionRow(desc: "test desc")
    }
}
