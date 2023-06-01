//
//  CoreDataRelationshipsApp.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

@main
struct CoreDataRelationshipsApp: App {
    
    @StateObject var dataController : DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ParentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
