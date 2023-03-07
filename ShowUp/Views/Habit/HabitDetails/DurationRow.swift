//
//  DurationRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct DurationRow: View {
    var duration: Int?

    var body: some View {
        HStack {
            Text("Duration: ")
                .bold()
            Spacer()
            Text("\(duration ?? 2)")
                .foregroundColor(.secondary)
        }.onAppear() {
        }
    }
}

struct DurationRow_Previews: PreviewProvider {
    static var previews: some View {
        DurationRow()
    }
}
