//
//  calenderView.swift
//  Micro
//
//  Created by Hajar Alshehri on 29/10/1445 AH.
//

import SwiftUI

struct calendarView: View {
    let calendar = Calendar.current
    @State private var selectedDate: Date = Date()
    @State private var showData = false
    @State private var showSheet = false
    @State private var isSheetPresented = false
    @State private var JamaahSheet = false
    let people: [peopleInfo] = []
    @State private var busyMembers: [peopleInfo] = []
    @State private var busyDays: Set<Date> = []
    @State private var someDateDate: Date = Date()
    @State private var groupName: String?
    @StateObject private var viewModel = GroupViewModel()
    @StateObject private var vm = PeopleViewModel()
       var body: some View {
           NavigationView {
               VStack {
                   HStack {
                       if let groupName = viewModel.groups.first?.name {
                           Text(groupName)
                               .foregroundColor(Color.black)
                               .fontWeight(.bold)
                               .font(.system(size: 34))
                               .offset(y: 6)
                               .offset(x: 10)
                       } else {
                           Text("No group found")
                               .foregroundColor(Color.black)
                               .fontWeight(.bold)
                               .font(.system(size: 34))
                               .offset(y: 6)
                               .offset(x: 10)
                       }

                    Spacer()

                }
                .padding([.top, .leading, .trailing]) // Add padding to the HStack

                   Divider()

                
                ZStack{
                    
                    
                    Rectangle()
                        .foregroundColor(Color("TextField"))
                        .frame(width: 350, height: 50)
                        .cornerRadius(18)
                        .offset(x: 5, y: 15)
                        .padding(.bottom, 20)
                    
                    
                    
                    HStack(spacing: -25) {
                            ForEach(vm.peopleInfo) { person in
                                              Image("memoji\(person.emoji)")
                                                  .offset(x: -90, y: 20)
                                                  .scaleEffect(0.7)
                                          }
                                      
                        
                    }
                    
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "ellipsis").foregroundColor(Color.gray)
                    }
                    .offset(x: 140, y: 5)
                    .sheet(isPresented: $showSheet) {
                        CreateView()
                              }
                    
                    Text("|")
                        .offset(x: 120, y: -5)
                        .foregroundColor(.gray)
                    Text("|")
                        .offset(x: 120, y: 10)
                        .foregroundColor(.gray)
                    Text("|")
                        .offset(x: 120, y: 10)
                        .foregroundColor(.gray)
                    
                    
                }
                
                
                   Divider()
                
                
                Spacer()
            }.toolbar {
                Button(action:{
                    JamaahSheet.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(Color("AccentColor"))
                    //                        .padding(.vertical,-50)
                }
            }
                        .sheet(isPresented: $JamaahSheet, content: {
                            PickGatheringDay_Sheet(selectedDate: someDateDate)})
            
        }.accentColor(Color("AccentColor"))
    }
}

//calendar
struct CalendarPage: View {
    @State private var selectedDate: Date?
    @State private var busyDays: [Date] = []
    @State private var currentDate: Date = Date()
    @State private var isSheetPresented: Bool = false
    @State private var selectedDay: Date?
    @State private var busyMembers: [peopleInfo] = []

    let people: [peopleInfo] = [
        peopleInfo(id: "id", emoji: 1, name: "Renad")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                calendarView()
                HStack {
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                    }.padding(.leading)
                    
                    Spacer()
                    
                    Text("\(currentDate, formatter: DateFormatter.monthYear)")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title)
                    }.padding(.trailing)
                }

                .padding()
                .offset(y: -50)
                
                // Pass 'people' to Calendar1View
                Calendar1View(selectedDate: $selectedDate, busyDays: $busyDays, currentDate: $currentDate, people: people) { day in
                    isSheetPresented = true
                    selectedDay = day
                }
                .padding()
                .sheet(isPresented: $isSheetPresented) {
                    BusyDaySheet(
                        isBusy: busyDays.contains(selectedDay ?? Date()),
                        onMarkBusy: {
                            if let selectedDay = selectedDay {
                                if busyDays.contains(selectedDay) {
                                    busyDays.removeAll { $0 == selectedDay }
                                } else {
                                    busyDays.append(selectedDay)
                                }
                            }
                            isSheetPresented = false
                        },
                        people: people
                    )
                }
                
                Divider()
                HStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color.gray)
                                        .frame(width: 16, height: 16)
                                        .offset(x:55)
                                    Text("يوم مشغول")
                                }
                                .padding(.trailing,50)
                                
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color("AccentColor"))
                                        .frame(width: 16, height: 16)
                                        .offset(x:55)
                                    Text("يوم الجَمعة")
                                }
                }.padding(.bottom, 25)
                
                Spacer()
            }
            .accentColor(Color("AccentColor"))
        }
    }
}

struct Calendar1View: View {
    @Binding var selectedDate: Date?
    @Binding var busyDays: [Date]
    @Binding var currentDate: Date
    var people: [peopleInfo] // Add people parameter
    var onDayTapped: (Date) -> Void
    @State private var isJamaahAdded: Bool = false
    @State private var highlightedDay: Date?
    @State private var selectedJamaahDay: Date?

    var body: some View {
        VStack {
            // Days of the week
            HStack(spacing: 27) {
                ForEach(DateFormatter().shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .offset(y: -50)
                }
            }
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(), count: 6)) {
                ForEach(monthDays(), id: \.self) { day in
                    DayView(
                        date: day,
                        isSelected: selectedDate == day,
                        isBusy: busyDays.contains(day),
                        isJamaahAdded: isJamaahAdded,
                        highlightedDay: day,
                        jamaahDay: selectedJamaahDay ?? Date() // Pass the appropriate date here
                    )
                    .onTapGesture {
                       
                        selectedDate = day
                        onDayTapped(day)
                 }
                    
                    
                }
            }
        }
    }
    // Helper function to get the days of the month
    private func monthDays() -> [Date] {
        let calendar = Calendar.current
        let monthRange = calendar.range(of: .day, in: .month, for: currentDate)!
        let days = monthRange.map { calendar.date(bySetting: .day, value: $0, of: currentDate)! }
        return days
    }
}

struct DayView: View {
    @EnvironmentObject var vm: ViewModel
    let date: Date
    let isSelected: Bool
    let isBusy: Bool
    let isJamaahAdded: Bool // Add this property
    var highlightedDay: Date?
    var allDates: [Date]{
        vm.jamaah.map{$0.selectedDate.startOfDay}
    }

    init(date: Date, isSelected: Bool, isBusy: Bool, isJamaahAdded: Bool, highlightedDay: Date?, jamaahDay: Date) {
        self.date = date
        self.isSelected = isSelected
        self.isBusy = isBusy
        self.isJamaahAdded = isJamaahAdded
        self.highlightedDay = highlightedDay
      
    }

    var body: some View {
        
              VStack {
                  Text("\(date.day)")
                      .foregroundColor(isBusy ? .gray : (isSelected ? .black : .primary))
                      .padding(8)
                .background {
                    if allDates.contains { $0 == date.startOfDay } {
                        Color("AccentColor")
                    }
                }
                .clipShape(Circle())
                .offset(y: -45)

        }
        
    }
}

//BusyDaySheet
struct BusyDaySheet: View {
    var isBusy: Bool
    var onMarkBusy: () -> Void
    var people: [peopleInfo]
    @State private var showUserInfo: Bool = false // Add a state variable
    
    var body: some View {
        NavigationView {
            VStack {
                Text("BusyMembers")
                    .font(.title).bold()
                    .padding(.trailing, 140)
                 
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width:335,height: 1)
                    .padding(.vertical,-20)
                
                Spacer()
                
                if isBusy || showUserInfo {
                    ForEach(people) { person in
                        HStack {
                            Image("memoji\(person.emoji)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text(person.name)
                                .font(.title3)
                        }
                    }
                }
                
                Spacer()
  
            } .toolbar {Button(action: {
                onMarkBusy()
                showUserInfo.toggle()
            }) {
                Text(isBusy ? Image(systemName: "plus.app.fill") : Image(systemName: "plus.app"))
                    .padding(.top,90)
                    .padding(.trailing,20)
                    .foregroundColor(Color("AccentColor"))
                    .cornerRadius(8)
            }
            }
        }
    }
}

extension Date{
    var startOfDay: Date{
        Calendar.current.startOfDay(for: self)
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
}

extension DateFormatter {
    static var monthYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}


struct CalendarPage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarPage()
            .environmentObject(ViewModel())
    }
}
