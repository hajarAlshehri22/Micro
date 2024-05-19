import SwiftUI

struct CardsPage: View {
    @State private var currentIndex: Int = 0  // State to track the current index of the displayed text
    
    @EnvironmentObject var vm: ViewModel
    
    let texts = ["سولف عن أحن ذكرى عائلية تتذكرها", "وش الموقف اللي خلاك تمر بلحظة ادراك عميقة", "لو قابلت أمك/أبوك بفترة شبابهم وش بتقولهم؟", "احكي لنا عن اول مره قابلت فيها أعز اصدقائك", "مصايب المراهقة كثيرة .. سولف لنا عن وحده منها","شاركنا الشي اللي مايعرفه احد من الموجودين عنك","وش الذكرى اللي تخليك مبتسم وانت تتذكرها؟","شلون تعرفت على كل شخص من الموجودين؟","وش الموقف اللي تتمنى انه ينعاد عشان تغير تصرفك فيه","وش الشخصيات الكرتونيه/السينمائية اللي تشبه كل شخص من الموجودين؟"]
    
    // Function to select a random text
    func selectRandomText() {
        currentIndex = Int.random(in: 0..<texts.count)
    }
                                      
    var body: some View {
        NavigationView {
            VStack {
                Image("EmptyCard")
                    .resizable()
                    .frame(width: 355, height: 494)
                    .padding(.top, 50)
                    .overlay(
                        // Display the text from the array in the center of the card
                        Text(texts[currentIndex])
                            .bold()
                            .foregroundColor(.black)  // Text color
                            .frame(width: 307) // Set the frame width
                            .multilineTextAlignment(.center), // Center the text
                        alignment: .center  // Center the text over the image
                    )
                
                Divider()
                    .padding(.vertical, -540)
                Button("اللّي بعده !") {
                    selectRandomText()
                }
                .frame(width: 280, height: 50)
                .background(Color("SecB"))
                .foregroundColor(.white)
                .cornerRadius(24)
                .padding(.top, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Majles")
                        .resizable()
                        .frame(width: 250, height: 70)
                        .padding(.top, -60)
                }
            }
            .onAppear{
                vm.shouldShowTabView = false
    //            print( vm.shouldShowTabView)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CardsPage()
}
