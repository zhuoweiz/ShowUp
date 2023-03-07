//
//  FrequencyRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct FrequencyRow: View {
    
    var frequency: Int?
    
    @State private var frequencyText: String = ""
    
    var body: some View {
        HStack {
            Text("Frequency: ")
                .bold()
            Spacer()
            Text("\(frequencyText)")
                .foregroundColor(.secondary)
        }.onAppear() {
            frequencyText = (frequency == 0 ? "Daily" : "Weekly")
        }
    }
}

struct FrequencyRow_Previews: PreviewProvider {
    static var previews: some View {
        FrequencyRow()
    }
}
