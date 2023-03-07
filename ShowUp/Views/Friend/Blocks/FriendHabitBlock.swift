//
//  FriendHabitBlock.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import SwiftUI

struct FriendHabitBlock: View {
    var habit: Habit
    
    @State private var frequencyText = ""
    @State private var startDateText = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(UIColor.systemGray5))
            
            HStack {
                NavigationLink(destination: FriendHabitDetailView(habit: habit)) {
                    VStack(alignment: .leading, spacing: 12, content: {
                        Text(habit.title ?? "")
                            .font(.system(size: 28))
                        Text(frequencyText)
                        Text(startDateText)
                    })
                        .padding()
                        .foregroundColor(.black)
                }
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color(UIColor.systemBlue))
                        .frame(width: 100)
                }
            }
        }
        .onAppear() {
            frequencyText = "Working " + (habit.frequency == 0 ? "Daily" : "Weekly")

            let date = habit.startDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            startDateText = "Since: \(dateFormatter.string(from: date ?? Date()))"
        }
        .frame(height: 150)
        .padding(.horizontal, 24)
    }
}

struct FriendHabitBlock_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
