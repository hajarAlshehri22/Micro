import SwiftUI

struct Entertainment: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                Divider()
                    .padding(.top)
                
                ZStack{
                    // Navigation Link that covers the rectangle area for tap interaction
                    NavigationLink(destination: CardsPage()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("FieldColor")) // Ensure this color is defined in your asset catalog
                            .frame(width: 350, height: 150)
                            .padding(.top, 30)
                    }
                    
                    // A second rectangle and additional content that is not part of the navigation link
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 130, height: 115).padding(.top, 30).padding(.horizontal, -157)
                        
                        Image("Cards").resizable().frame(width: 120, height:100).padding(.top, 30).padding(.horizontal, -150.5)
                        
                        VStack{
                            Image("Majles").resizable().frame(width: 150, height:45).padding(.top,20).padding(.leading, 150)
                            
                            Divider().frame(width: 165).padding(.leading, 150)
                            
                            Text("بطاقات ترفيهية لمجلس مافيه نفس ثقيلة").font(.subheadline).frame(width: 200).padding(.leading, 150)
                        }
                    }
                }
                Spacer()
                
            }
            .onAppear{
                vm.shouldShowTabView = true
    //            print( vm.shouldShowTabView)
            }
            .navigationTitle("فعاليات")
        } // NavigationView
    } // Body
}

#Preview {
    Entertainment()
}
