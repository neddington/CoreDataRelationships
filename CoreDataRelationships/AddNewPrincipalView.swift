//
//  AddPrincipalView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 27/03/22.
//

import SwiftUI

enum ActiveAlertPrincipal {
    case first, second, third, zero
}

struct AddNewPrincipalView: View {
    
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
            .navigationTitle("Add New Interview")
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
                case .second:
                    return Alert(title: Text("Age is incorrect"), message: Text("Please enter an integer"), dismissButton: .default(Text("OK")))
                case .third:
                    return Alert(title: Text("Experience is incorrect"), message: Text("Please enter an integer"), dismissButton: .default(Text("OK")))
               
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

struct AddPrincipalView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        return AddNewPrincipalView(session: session).environment(\.managedObjectContext, dataController.container.viewContext).environmentObject(dataController)
    }
}
