//
//  DataController.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 25/03/22.
//

import Foundation
import CoreData
import SwiftUI


class DataController : ObservableObject {
    let container : NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "CoreDataRelationships")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading Core Data stores \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        let session1 = Session(context: viewContext)
        session1.id = UUID()
        session1.name = "Hogwarts Faculty Session"
        session1.date = Date()
        
        let session2 = Session(context: viewContext)
        session2.id = UUID()
        session2.name = "Hogwarts Head Master/Mistress Session"
        session2.date = Date()
        
        let interview = Interview(context: viewContext)
        interview.id = UUID()
        interview.name = "Potions Interview"
        interview.session = session1
        
        
        let question1 = Question(context: viewContext)
        question1.id = UUID()
        question1.name = "Minerva McGonagall"
        question1.date = Date()
        question1.interview = interview
        question1.session = session1
        
        let question2 = Question(context: viewContext)
        question2.id = UUID()
        question2.name = "Severus Snape"
        question2.date = Date()
        question2.interview = interview
        question2.session = session2
        
        let question3 = Question(context: viewContext)
        question3.id = UUID()
        question3.name = "Pomona Sprout"
        question3.date = Date()
        question3.interview = interview
        question3.session = session1
        
        let question4 = Question(context: viewContext)
        question4.id = UUID()
        question4.name = "Rubeus Hagrid"
        question4.date = Date()
        question4.interview = interview
        question4.session = session1
        
        let question5 = Question(context: viewContext)
        question5.id = UUID()
        question5.name = "Gilderoy Lockhart"
        question5.date = Date()
        question5.interview = interview
        question5.session = session1
        
        let response1 = Response(context: viewContext)
        response1.id = UUID()
        response1.name = "Hermione Granger"
        response1.date = Date()
        response1.session = session2
        response1.interview = interview
        response1.question = [question1, question2, question3, question4, question5]
        
        let response2 = Response(context: viewContext)
        response2.id = UUID()
        response2.name = "Percy Weasley"
        response1.date = Date()
        response1.session = session2
        response1.interview = interview
        response1.question = [question1, question2, question3, question4, question5]
        
        
        let response3 = Response(context: viewContext)
        response3.id = UUID()
        response3.name = "Neville Longbottom"
        response3.date = Date()
        response3.session = session2
        response3.interview = interview
        response3.question = [question1, question2, question3, question4, question5]
        
        let response4 = Response(context: viewContext)
        response4.id = UUID()
        response4.name = "Harry Potter"
        response4.date = Date()
        response4.session = session1
        response4.interview = interview
        response4.question = [question1, question2, question3, question4, question5]
        
        let response5 = Response(context: viewContext)
        response5.id = UUID()
        response5.name = "Ginny Weasley"
        response5.date = Date()
        response5.session = session2
        response5.interview = interview
        response5.question = [question1, question2, question3, question4, question5]
        
        let response6 = Response(context: viewContext)
        response6.id = UUID()
        response6.name = "Draco Malfoy"
        response6.date = Date()
        response6.session = session1
        response6.interview = interview
        response6.question = [question1, question2, question3, question4, question5]
        
        let response7 = Response(context: viewContext)
        response7.id = UUID()
        response7.name = "Ron Weasley"
        response7.date = Date()
        response7.session = session2
        response7.interview = interview
        response7.question = [question1, question2, question3, question4, question5]
        
        let response8 = Response(context: viewContext)
        response8.id = UUID()
        response8.name = "Luna Lovegood"
        response8.date = Date()
        response8.session = session1
        response8.interview = interview
        response8.question = [question1, question2, question3, question4, question5]
        
        let response9 = Response(context: viewContext)
        response9.id = UUID()
        response9.name = "Cho Chang"
        response9.date = Date()
        response9.session = session2
        response9.interview = interview
        response9.question = [question1, question2, question3, question4, question5]
        
        let response10 = Response(context: viewContext)
        response10.id = UUID()
        response10.name = "Parvati Patil"
        response10.date = Date()
        response10.session = session1
        response10.interview = interview
        response10.question = [question1, question2, question3, question4, question5]
        
        do {
            try viewContext.save()
        }
        catch {
            fatalError("Unable to load sample data: \(error.localizedDescription)")
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            }
            catch {
                fatalError("Unable to save data: \(error.localizedDescription)")
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Session.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
    
    static var preview : DataController = {
        let dataController = DataController()
        let viewContext = dataController.container.viewContext
        dataController.deleteAll() // Delete existing data
         dataController.createSampleData() // Load new sample data
        return dataController
    }()
}
