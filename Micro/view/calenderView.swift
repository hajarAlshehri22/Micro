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
                        .font(.system(size: 34))
                        .padding(.trailing, 250)
                } else {
                    Text("Loading...")
                        .foregroundColor(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 34))
                        .padding(.top, -30)
                        .padding(.leading, -100)
                }
            }

            Divider()

            ZStack {
                Rectangle()
                    .foregroundColor(Color("TextField"))
                    .frame(width: 360, height: 60)
                    .cornerRadius(18)
                    .padding(.top, 30)

                HStack(spacing: -35) {
                    ForEach(people) { person in
                        Image("memoji\(person.emoji)")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding(.leading, -100)
                            .padding(.bottom, -30)
                    }
                }

                NavigationLink(destination: peopleView(groupName: "")) {
                    Image(systemName: "ellipsis").foregroundColor(Color.gray)
                }
                .padding(.top, 25)
                .padding(.leading, 250)
            }

            Divider()
                .padding(.top, 20)

            Spacer()
        }
        .toolbar {
            Button(action: {
                JamaahSheet.toggle()
            }) {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.bottom,120)
        
            }
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
    @State private var selectedDay: Date?
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
                        Button("<") {
                            viewModel.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentDate) ?? viewModel.currentDate
                        }
                        .font(.title)
                        .padding(.leading)
                        Spacer()
                        Text("\(viewModel.currentDate, formatter: DateFormatter.monthYear)")
                            .font(.title2)
                        Spacer()
                        Button(">") {
                            viewModel.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentDate) ?? viewModel.currentDate
                        }
                        .font(.title)
                        .padding(.trailing)
                    }
                    .padding(.top)
                    .padding(.bottom, 20)

                    Calendar00View(
                        busyDays: $viewModel.busyDays,
                        currentDate: $viewModel.currentDate,
                        someDateDate: $someDateDate,
                        JamaahSheet: $JamaahSheet,
                        people: group.members,
                        onDayTapped: { day in
                            isSheetPresented = true
                            selectedDay = day

                            if let event = findEvent(on: day) {
                                selectedEvent = event
                            } else {
                                selectedEvent = nil
                            }
                        },
                        selectedJamaahDay: $selectedJamaahDay,
                        selectedEvent: $selectedEvent
                    )
                    .padding()
                    .sheet(isPresented: $isSheetPresented) {
                        BusyMembers(
                            busyMembers: $busyMembers
                        )
                    }
                    .presentationDetents([.medium])
                    .sheet(item: $viewModel.selectedEvent) { event in
                        eventDetailView(event: event)
                    }
                    .presentationDetents([.medium])

                    Divider()
                        .padding(.top)

                    EventsListView(events: viewModel.jamaah.map { Event(id: UUID().uuidString, name: $0.gatheringName, date: $0.selectedDate, locationURL: $0.locationURL) })
                }
                .padding(.bottom, 50) // To give some space at the bottom
            }
            .onAppear {
                viewModel.loadEvents(groupID: group.id ?? "")
            }
            .accentColor(Color("SecB"))
        }
        .sheet(isPresented: $JamaahSheet, onDismiss: {
            viewModel.loadEvents(groupID: group.id ?? "")
        }) {
            PickGatheringDay_Sheet(selectedDate: someDateDate, groupID: group.id ?? "")
                .environmentObject(viewModel)
        }
    }

    private func findEvent(on date: Date) -> Event? {
        if let jamaah = viewModel.jamaah.first(where: { Calendar.current.isDate($0.selectedDate, inSameDayAs: date) }) {
            return Event(id: UUID().uuidString, name: jamaah.gatheringName, date: jamaah.selectedDate, locationURL: jamaah.locationURL)
        }
        return nil
    }
}

struct Calendar00View: View {
    let calendar = Calendar.current
    @Binding var busyDays: [Date]
    @Binding var currentDate: Date
    @Binding var someDateDate: Date
    @Binding var JamaahSheet: Bool
    var people: [peopleInfo]
    var onDayTapped: (Date) -> Void
    @State private var isSheetPresented = false
    @State private var isJamaahAdded: Bool = false
    @State private var highlightedDay: Date?
    @Binding var selectedJamaahDay: Date?
    @Binding var selectedEvent: Event?
    @State private var busyMembers: [peopleInfo] = []
    @State private var selectedDate: Date = Date()

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
                    DayView(
                        date: day,
                        isSelected: selectedDate == day,
                        isBusy: busyDays.contains(day),
                        isJamaahAdded: isJamaahAdded,
                        highlightedDay: day,
                        jamaahDay: selectedJamaahDay ?? Date(),
                        allDates: busyDays
                    )
                    .onTapGesture {
                        selectedDate = day
                        onDayTapped(day)
                        selectedEvent = Event(id: UUID().uuidString, name: "Sample Event", date: day, locationURL: "Sample Location")
                    }
                }
            }
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
    let isJamaahAdded: Bool
    var highlightedDay: Date?
    var jamaahDay: Date
    var allDates: [Date]

    var body: some View {
        VStack {
            Text("\(date.day)")
                .foregroundColor(isBusy ? .gray : (isSelected ? .black : .primary))
                .padding(8)
                .background {
                    if allDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                        Color("LightPurble")
                    }
                }
                .clipShape(Circle())
                .offset(y: -45)

            Circle()
                .foregroundColor(isBusy ? Color.gray : Color.purple)
                .frame(width: 6, height: 6)
                .padding(.top, -4)
                .opacity(isBusy ? 1.0 : 0.0)
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
