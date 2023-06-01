//
//  AddPrincipalView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

enum ActiveAlertPrincipal {
    case first, zero
}

struct AddNewInterviewView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController : DataController
    
    let session : Session
    
    @State private var showAlert : Bool = false
    @State private var activeAlert : ActiveAlertPrincipal = .zero
    
    @State private var name = ""

    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Name")) {
                    TextField("Enter a name", text: $name)
                }

            }
            .navigationTitle("Add New Principal")
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
            .alert(isPresented : $showAlert) {
                switch activeAlert {
                case .first:
                    return Alert(title: Text("Name is empty"), message: Text("Please enter name"), dismissButton: .default(Text("OK")))
               
                case .zero:
                    return Alert(title: Text("Name is empty"), message: Text("Please enter name"), dismissButton: .cancel())
                }
            }
        }
    }
    
    func saveButton() {
    
        //Validation for textfields
        if self.name == "" {
            self.activeAlert = .first
            self.showAlert = true
        }
          
        else {
            let interview = Interview(context: dataController.container.viewContext)
            
            interview.id = UUID()
            interview.name = self.name
            interview.session = self.session
            
            dataController.save()
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddInterviewView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        return AddNewInterviewView(session: session).environment(\.managedObjectContext, dataController.container.viewContext).environmentObject(dataController)
    }
}
