//
//  Event.swift
//  Micro
//
//  Created by Hajar Alshehri on 27/10/1445 AH.
//



import Foundation
import Firebase
import FirebaseFirestore

class Event: ObservableObject{
    @Published var  list : [EventDetails] = []
    
    
    func addData(name: String, location:String){
        
        // Get a refrence to the database
        let db = Firestore.firestore()
        
        // Add a document to a collection
        db.collection("Event").addDocument(data: ["name":name, "location":location]) { error in
            
            if error == nil {
                
                // Call get data to retrive data
                self.addData(name: "Haja", location: "httpsnkernq")
            }
            else {
                
            }
            
        }
    }
    
}
    
    
    // event struct //
    

struct EventDetails: Identifiable, Codable{
    var id: String
    var name: String
    var Location: String
}


