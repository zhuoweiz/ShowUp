//
//  HabitBlock.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct HabitBlock: View {
    var habit: Habit
    
    @State private var frequencyText = ""
    @State private var startDateText = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(UIColor.systemGray5))
            
            HStack {
                NavigationLink(destination: HabitDetailView(habit: habit)) {
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

                NavigationLink(destination: AddPostView(habitId: habit.id, fetchFlag: .constant(true))) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color(UIColor.systemBlue))
                            .frame(width: 100)
                        
                        Text("+")
                            .foregroundColor(.white)
                            .font(.system(size: 48))
                    }
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

struct HabitBlock_Previews: PreviewProvider {
    static var previews: some View {
//        HabitBlock()
        EmptyView()
    }
}
