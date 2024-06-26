
import SwiftUI
import Firebase
import FirebaseFirestore

struct calendar1View: View {
    @EnvironmentObject var viewModel: ViewModel
    let calendar = Calendar.current
    @State private var selectedDate: Date = Date()
    @State private var showData = false
    @State private var showSheet = false
    @State private var isSheetPresented = false
    @Binding var someDateDate: Date
    @Binding var selectedEvent: Event?
    @Binding var JamaahSheet: Bool
    var people: [peopleInfo] = []
    @State private var busyMembers: [peopleInfo] = []
    @State private var busyDays: Set<Date> = []
    @StateObject private var groupViewModel = GroupViewModel()
    @EnvironmentObject var vm: ViewModel
    let groupID: String
    
    var body: some View {
        VStack {
            HStack {
                if let groupName = groupViewModel.groups.first(where: { $0.id == groupID })?.name {
                    Text(groupName)
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(.system(size: 24))  // Adjust font size to match your style
                } else {
                    Text("Loading...")
                        .foregroundColor(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                }
                Spacer()
                Button(action: {
                    JamaahSheet.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding([.leading, .trailing, .top])
            
            Divider()
            
//            ZStack {
//                Rectangle()
//                    .foregroundColor(Color("TextField"))
//                    .frame(width: 360, height: 60)
//                    .cornerRadius(18)
//                    .padding(.top, 16)  // Adjust top padding
//                
//                HStack(spacing: -20) {  // Adjust spacing
//                    ForEach(people) { person in
//                        Image("memoji\(person.emoji)")
//                            .resizable()
//                            .frame(width: 45, height: 45)
//                    }
//                }
//                
//                NavigationLink(destination: peopleView(groupName: "")) {
//                    Image(systemName: "ellipsis").foregroundColor(Color.gray)
//                }
//                .padding(.top, 25)
//                .padding(.leading, 250)
//            }
            
//            Divider()
//                .padding(.top, 10)  // Reduce top padding
            
            Spacer()
        }
        .sheet(isPresented: $JamaahSheet) {
            PickGatheringDay_Sheet(selectedDate: someDateDate, groupID: groupID)
        }
        .onAppear {
            groupViewModel.fetchGroupData(groupID: groupID)
        }
    }
}

struct CalendarPage: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedDate: Date?
    @State private var busyDays: [Date] = []
    @State private var currentDate: Date = Date()
    @State private var isSheetPresented: Bool = false
    @State private var selectedDay: Date = Date()
    @State private var busyMembers: [peopleInfo] = []
    @State private var selectedEvent: Event?
    @State private var JamaahSheet: Bool = false
    @State private var someDateDate: Date = Date()
    @State private var selectedJamaahDay: Date?
    let group: Group
    
    public init(group: Group) {
        self.group = group
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    calendar1View(
                        someDateDate: $someDateDate,
                        selectedEvent: $viewModel.selectedEvent,
                        JamaahSheet: $JamaahSheet,
                        people: group.members,
                        groupID: group.id ?? ""
                    )
                    .environmentObject(viewModel)
                    HStack {
                        Button(">") {
                            viewModel.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentDate) ?? viewModel.currentDate
                        }
                        .font(.title)
                        .padding(.leading)
                        Spacer()
                        Text("\(viewModel.currentDate, formatter: DateFormatter.monthYear)")
                            .font(.title2)
                        Spacer()
                        Button("<") {
                            viewModel.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentDate) ?? viewModel.currentDate
                        }
                        .font(.title)
                        .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 70)
                    
                    Calendar00View(
                        busyDays: $viewModel.busyDays,
                        gatheringDays: $viewModel.gatheringDays, // Add this binding
                        currentDate: $viewModel.currentDate,
                        someDateDate: $someDateDate,
                        JamaahSheet: $JamaahSheet,
                        people: group.members,
                        onDayTapped: { day in
                            selectedDay = day
                            isSheetPresented = true
                            fetchBusyMembers(for: day)
                        },
                        selectedEvent: $selectedEvent,
                        selectedJamaahDay: $selectedJamaahDay
                    )
                    .padding()
                    .sheet(isPresented: $isSheetPresented, onDismiss: {
                        fetchBusyMembers(for: selectedDay)
                    }) {
                        BusyMembers(selectedDate: $selectedDay, groupID: group.id ?? "")
                            .environmentObject(viewModel)
                    }
                    
                        .padding(.top)
                    // Color palette legend
                    HStack {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 20, height: 20)
                            Text("يوم مشغول")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.leading)
                        Spacer()
                        HStack {
                            Circle()
                                .fill(Color("LightPurble"))
                                .frame(width: 20, height: 20)
                            Text("يوم الجَمعة")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing,20)
                    }
                    .padding(.vertical, 3) // Vertical padding to separate from other elements
                    
                    Divider()
                        .padding(.top)
                    EventsListView(events: viewModel.jamaah.map { Event(id: UUID().uuidString, name: $0.gatheringName, date: $0.selectedDate, locationURL: $0.locationURL) })
                }
                .padding(.bottom, 50) // To give some space at the bottom
            }
            .onAppear {
                guard let userId = Auth.auth().currentUser?.uid else { return }
                viewModel.fetchCurrentUser(userID: userId)
                viewModel.loadEvents(groupID: group.id ?? "")
                viewModel.fetchBusyDays(groupID: group.id ?? "")
            }
            .accentColor(Color("SecB"))
        }
        .sheet(isPresented: $JamaahSheet, onDismiss: {
            viewModel.loadEvents(groupID: group.id ?? "")
            viewModel.fetchBusyDays(groupID: group.id ?? "")
        }) {
            PickGatheringDay_Sheet(selectedDate: someDateDate, groupID: group.id ?? "")
                .environmentObject(viewModel)
        }
    }
    
    private func fetchBusyMembers(for date: Date) {
        viewModel.fetchBusyMembers(date: date, groupID: group.id ?? "")
    }
}

struct Calendar00View: View {
    let calendar = Calendar.current
    @Binding var busyDays: [Date]
    @Binding var gatheringDays: [Date]
    @Binding var currentDate: Date
    @Binding var someDateDate: Date
    @Binding var JamaahSheet: Bool
    var people: [peopleInfo]
    var onDayTapped: (Date) -> Void
    @Binding var selectedEvent: Event?
    @Binding var selectedJamaahDay: Date?
    @State private var isSheetPresented = false
    @State private var selectedDate: Date = Date()
    @State private var busyMembers: [peopleInfo] = []
    @State private var showBusyMembersSheet = false
    
    var body: some View {
        VStack {
            // Days of the week
            HStack(spacing: 27) {
                ForEach(DateFormatter().shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, -50)
                }
            }
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(monthDays(), id: \.self) { day in
                    let isGathering = gatheringDays.contains(where: { Calendar.current.isDate($0, inSameDayAs: day) })
                    let isBusy = busyDays.contains(where: { Calendar.current.isDate($0, inSameDayAs: day) })
                    DayView(
                        date: day,
                        isSelected: selectedDate == day,
                        isBusy: isBusy,
                        isGathering: isGathering
                    )
                    .onTapGesture {
                        selectedDate = day
                        onDayTapped(day)
                    }
                }
            }
        }
        .sheet(isPresented: $showBusyMembersSheet) {
            BusyMembers(selectedDate: $selectedDate, groupID: "sampleGroupID")
                .environmentObject(ViewModel()) // Replace with actual groupID and ViewModel
        }
    }
    
    // Helper function to get the days of the month
    private func monthDays() -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: firstDay) }
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let isBusy: Bool
    let isGathering: Bool
    
    var body: some View {
        VStack {
            Text("\(date.day)")
                .foregroundColor(isSelected ? .black : .primary)
                .padding(8)
                .background {
                    if isGathering {
                        Color("LightPurble")
                    } else if isBusy {
                        Color.gray.opacity(0.5)
                    }
                }
                .clipShape(Circle())
                .offset(y: -45)
        }
    }
}

extension Date {
    var startOfDay: Date {
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
        let sampleGroup = Group(id: "sampleID", name: "Sample Group", members: [
            peopleInfo(id: "1", emoji: 1, name: "John Doe"),
            peopleInfo(id: "2", emoji: 2, name: "Jane Smith"),
        ])
        CalendarPage(group: sampleGroup)
            .environmentObject(ViewModel())
    }
}
