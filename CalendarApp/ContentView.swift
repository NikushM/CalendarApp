import SwiftUI

struct DailyPlan {
    var tasks: Set<String>
}

struct MonthlyPlan {
    var days: [Int: DailyPlan] = [:]
    
    mutating func addPlan(day: Int, task: String) {
        if days[day] == nil {
            days[day] = DailyPlan(tasks: [])
        }
        days[day]?.tasks.insert(task)
    }
}

struct YearlyPlan {
    var months: [String: MonthlyPlan] = [:]
    
    mutating func addPlan(month: String, day: Int, task: String) {
        if months[month] == nil {
            months[month] = MonthlyPlan()
        }
        months[month]?.addPlan(day: day, task: task)
    }
}

struct Journal {
    var planner = YearlyPlan()
    
    func showMonthPlans(month: String) -> [Int: Set<String>] {
        return planner.months[month]?.days.mapValues { $0.tasks } ?? [:]
    }
}

struct ContentView: View {
    @State private var selectedMonth: String = "Лютий"
    @State private var journal = Journal()
    
    let months = ["Січень", "Лютий", "Березень", "Квітень", "Травень", "Червень"]
    
    var body: some View {
        VStack {
            Text("Розклад на місяць")
                .font(.title)
                .padding()
            
            TextField("Введіть місяць", text: $selectedMonth)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(months, id: \.self) { month in
                        Button(action: {
                            selectedMonth = month
                        }) {
                            Text(month)
                                .padding()
                                .background(selectedMonth == month ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            
            List {
                ForEach(journal.showMonthPlans(month: selectedMonth).keys.sorted(), id: \.self) { day in
                    VStack(alignment: .leading) {
                        Text("День \(day):")
                            .bold()
                        Text(journal.showMonthPlans(month: selectedMonth)[day]?.joined(separator: ", ") ?? "")
                    }
                }
            }
        }
        .onAppear {
            journal.planner.addPlan(month: "Лютий", day: 1, task: "Ознайомлення з Swift")
            journal.planner.addPlan(month: "Лютий", day: 3, task: "Встановлення Xcode")
            journal.planner.addPlan(month: "Лютий", day: 5, task: "Практика Swift")
            journal.planner.addPlan(month: "Січень", day: 25, task: "Прибирання")
            journal.planner.addPlan(month: "Січень", day: 18, task: "Навчання")
            journal.planner.addPlan(month: "Березень", day: 20, task: "Шопінг")
            journal.planner.addPlan(month: "Квітень", day: 9, task: "Ознайомлення з Swift")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
