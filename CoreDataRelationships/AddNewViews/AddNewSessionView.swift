//
//  AddNewSession.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

enum ActiveAlertSession {
    case first, zero
}

struct AddNewSessionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController : DataController
    
    @State private var name : String = ""
    
    @State private var showAlert : Bool = false
    @State private var activeAlert: ActiveAlertSession = .zero
    
    var body: some View {
        NavigationView {
            Form {
                Section (header : Text("Name")) {
                    TextField("Enter name", text: $name)
                }
            }
            .navigationTitle("Add new Session")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveButton()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .first:
                    return Alert(title: Text("Session name is empty"), message: Text("Enter session name"), dismissButton: .default(Text("OK")))
                case .zero:
                    return Alert(title: Text("Incorrect data"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    func saveButton(){
        
        //Validation for textfields
        if self.name.isEmpty {
            self.activeAlert = .first
            self.showAlert = true
        }
        
        else {
            let session = Session(context: dataController.container.viewContext)
            
            session.id = UUID()
            session.date = Date()
            session.name = self.name

            
            dataController.save()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddNewSession_Previews: PreviewProvider {
    static var previews: some View {
        AddNewSessionView()
    }
}
