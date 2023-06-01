//
//  DataController.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
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
        
        let interview1 = Interview(context: viewContext)
        interview1.id = UUID()
        interview1.name = "Potions Interview"
        interview1.session = session1
        
        let interview2 = Interview(context: viewContext)
        interview2.id = UUID()
        interview2.name = "Defense Against Dark Arts Interview"
        interview2.session = session1
        
        
        let question1 = Question(context: viewContext)
        question1.id = UUID()
        question1.name = "What sparked your interest about working at Hogwarts?"
        question1.date = Date()
        question1.session = session1
        
        let question2 = Question(context: viewContext)
        question2.id = UUID()
        question2.name = "What would you say the most peculiar thing is about the Wizarding World?"
        question2.date = Date()
        question2.session = session2
        
        let question3 = Question(context: viewContext)
        question3.id = UUID()
        question3.name = "What is your experience working with Defense against the dark arts?"
        question3.date = Date()
        question3.session = session1
        
        let question4 = Question(context: viewContext)
        question4.id = UUID()
        question4.name = "What uniqueness do you believe you'd bring to Hogwarts?"
        question4.date = Date()
        question4.session = session1
        
        let question5 = Question(context: viewContext)
        question5.id = UUID()
        question5.name = "What do you know about the history of the school and how it came to be?"
        question5.date = Date()
        question5.session = session1
        
        let questionInterview1 = QuestionInterview(context: viewContext)
        questionInterview1.question = question1
        questionInterview1.interview = interview1
        
        let questionInterview2 = QuestionInterview(context: viewContext)
        questionInterview2.question = question2
        questionInterview2.interview = interview1
        
        let questionInterview3 = QuestionInterview(context: viewContext)
        questionInterview3.question = question3
        questionInterview3.interview = interview1
        
        let questionInterview4 = QuestionInterview(context: viewContext)
        questionInterview4.question = question4
        questionInterview4.interview = interview1
        
        let questionInterview5 = QuestionInterview(context: viewContext)
        questionInterview5.question = question5
        questionInterview5.interview = interview2
        
        let response1 = Response(context: viewContext)
        response1.id = UUID()
        response1.name = "The fact that the castle is always moving and theres always something different to see."
        response1.date = Date()
        response1.session = session2
        response1.interview = interview1
        response1.question = [question1]
        
        let response2 = Response(context: viewContext)
        response2.id = UUID()
        response2.name = "All the intricate creatures you won't find anywhere else"
        response1.date = Date()
        response1.session = session2
        response1.interview = interview1
        response1.question = [question2]
        
        
        let response3 = Response(context: viewContext)
        response3.id = UUID()
        response3.name = "Only what my mother taught me."
        response3.date = Date()
        response3.session = session2
        response3.interview = interview1
        response3.question = [question3]
        
        let response4 = Response(context: viewContext)
        response4.id = UUID()
        response4.name = "I'm strange so I should fit right in!"
        response4.date = Date()
        response4.session = session1
        response4.interview = interview1
        response4.question = [question4]
        
        let response5 = Response(context: viewContext)
        response5.id = UUID()
        response5.name = "Only from what I've learned from reaching, watching and playing Harry Potter."
        response5.date = Date()
        response5.session = session2
        response5.interview = interview1
        response5.question = [question5]
        
        
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
        let entities = container.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            _ = try? container.viewContext.execute(deleteRequest)
        }
        
        
    }
    static var preview : DataController = {
        let dataController = DataController()
        let viewContext = dataController.container.viewContext
        dataController.deleteAll() // Delete existing data
         dataController.createSampleData() // Load new sample data
        return dataController
    }()
}
