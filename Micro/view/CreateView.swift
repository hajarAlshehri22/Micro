import SwiftUI

struct CreateView: View {
    
    @State var groupName: String = ""
    @EnvironmentObject var vm: ViewModel
    
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                VStack(spacing: 20){
                    

                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color("AccentColor"))
                        .frame(width: 165, height: 2)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("LightPurble"))
                        .frame(width: 165, height: 2)
                    
                }
                    
                  Spacer()
     
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(LocalizedStringKey("اسم المجموعة")) // Localized string key
                            .foregroundColor(Color("Text"))
                                  .fontWeight(.regular)
                                  .padding(.leading, 16).font(.title2)
                    TextField(LocalizedStringKey("ادخل اسم المجموعة"), text: $groupName).padding() // Localized string key
                            .frame(width:340,height: 36)
                            .background(Color("TextField"))
                            .cornerRadius(18).foregroundColor(Color("Text"))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: peopleView(groupName: groupName)) {
                        Text(("اجمع")).padding().frame(width: 189, height: 48).background(Color("AccentColor")).foregroundColor(.white).cornerRadius(24).bold().font(.headline)
                    }
                    
           
                  
                    
            }
                .navigationBarTitle(LocalizedStringKey("جمّعهم"), displayMode: .large) .foregroundColor(Color("Text"))
                
        }
            .onAppear{
                            vm.shouldShowTabView = false
                //            print( vm.shouldShowTabView)
                        }
        }
    }
}
struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .environment(\.locale, .init(identifier: "ar"))
    }
}
