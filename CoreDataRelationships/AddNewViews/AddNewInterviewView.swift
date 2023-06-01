//
//  AddPrincipalView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

enum ActiveAlertInterview {
    case first, zero
}

struct AddNewInterviewView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataController: DataController
    
    let session: Session
    
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlertInterview = .zero
    
    @State private var name = ""
    @State private var selectedQuestions: Set<Question> = []
    
    @FetchRequest(entity: Question.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Question.name, ascending: true)])
    var questions: FetchedResults<Question>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter a name", text: $name)
                }
                
                Section(header: Text("Select Questions")) {
                    List(questions, id: \.self) { question in
                        QuestionRow(question: question, isSelected: selectedQuestions.contains(question)) { isSelected in
                            updateSelectedQuestions(question: question, isSelected: isSelected)
                        }
                    }
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
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .first:
                    return Alert(title: Text("Name is empty"), message: Text("Please enter a name"), dismissButton: .default(Text("OK")))
                    
                case .zero:
                    return Alert(title: Text("Name is empty"), message: Text("Please enter a name"), dismissButton: .cancel())
                }
            }
        }
    }
    
    func saveButton() {
        
        // Validation for textfields
        if self.name.isEmpty {
            self.activeAlert = .first
            self.showAlert = true
        } else {
            let interview = Interview(context: dataController.container.viewContext)
            
            interview.id = UUID()
            interview.name = self.name
            interview.session = self.session
            
            // Add selected questions to the interview
            for question in selectedQuestions {
                let questionInterview = QuestionInterview(context: dataController.container.viewContext)
                questionInterview.question = question
                questionInterview.interview = interview
            }
            
            dataController.save()
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func updateSelectedQuestions(question: Question, isSelected: Bool) {
        if isSelected {
            selectedQuestions.insert(question)
        } else {
            selectedQuestions.remove(question)
        }
    }
}
    

struct QuestionRow: View {
    let question: Question
    let isSelected: Bool
    let toggleSelection: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            toggleSelection(!isSelected)
        }) {
            HStack {
                Text(question.name ?? "")
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct AddInterviewView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        return AddNewInterviewView(session: session)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
