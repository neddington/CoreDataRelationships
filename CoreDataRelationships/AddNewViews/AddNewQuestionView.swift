//
//  AddTeacherView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 27/03/22.
//

import SwiftUI

enum ActiveAlertQuestion {
    case first, zero
}

struct AddNewQuestionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController : DataController
    
    let session : Session
    
    @State private var activeAlert: ActiveAlertQuestion = .zero
    @State private var showAlert : Bool = false
    
    @State private var name: String = ""

    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Question")) {
                    TextField("Enter question", text: $name)
                }
            }
            .navigationTitle("Add new Question")
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
                    
                case .first :
                    return Alert(title: Text("Name is empty"), message: Text("Please enter name"), dismissButton: .default(Text("OK")))
                case .zero :
                    return Alert(title: Text("Field is empty"), dismissButton: .default(Text("OK")))
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
            let newQuestion = Question(context: dataController.container.viewContext)
            newQuestion.date = Date()
            newQuestion.name = self.name
            newQuestion.session = self.session
            newQuestion.id = UUID()
            newQuestion.interview = self.session.interview
            newQuestion.response = self.session.response
            
            dataController.save()
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        
        AddNewQuestionView(session: session )
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
