//
//  AddNewStudent.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 27/03/22.
//

import SwiftUI

enum ActiveAlertStudent {
    case first, zero
}

struct AddNewStudentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController : DataController
    
    @State private var response: String = ""
    
    @State private var showAlert : Bool = false
    @State private var activeAlert: ActiveAlertStudent = .zero
    
    let session : Session
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Response")) {
                    TextField("Enter response", text: $response)
                }
            }
            .navigationTitle("Add new Response")
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
                    return Alert(title: Text("Name is empty"), message: Text("Please enter name"), dismissButton: .default(Text("OK")))
                case .zero:
                    return Alert(title: Text("Incorrect data"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    func saveButton(){
        
        //Validation for textfields
        if self.response.isEmpty {
            self.activeAlert = .first
            self.showAlert = true
        }

        
        else {
            let response = Response(context: dataController.container.viewContext)
            
            response.response = self.response
            response.id = UUID()
            response.session = self.session
            response.interview = self.session.interview
            response.question = self.session.question
            
            dataController.save()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddNewStudent_Previews: PreviewProvider {
    static let dataController = DataController.preview
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        AddNewStudentView(session: session)
    }
}
