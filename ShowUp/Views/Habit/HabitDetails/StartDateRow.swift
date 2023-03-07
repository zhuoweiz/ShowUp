//
//  StartDateRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct StartDateRow: View {
    var startDate: Date?
    
    @State private var startDateText: String = ""
    
    var body: some View {
        HStack {
            Text("StartDate: ")
                .bold()
            Spacer()
            Text("\(startDateText)")
                .foregroundColor(.secondary)
        }.onAppear() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            startDateText = "\(dateFormatter.string(from: startDate ?? Date()))"
        }
    }
}

struct StartDateRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
