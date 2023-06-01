//
//  QuestionDetailView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

struct QuestionDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var question: Question
    
    var session: Session? {
        question.session
    }
    var interviews: [Interview] {
        question.questionInterviews?.compactMap { ($0 as? QuestionInterview)?.interview } ?? []
    }
    var response: [Response] {
        question.response?.allObjects as? [Response] ?? []
    }
    
    var questionNameBinding: Binding<String> {
        Binding<String>(
            get: { question.name ?? "" },
            set: { question.name = $0 }
        )
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question")) {
                    TextField("Question", text: questionNameBinding)
                }
            }
            .navigationTitle("Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveChanges) {
                        Text("Save")
                    }
                }
            }
        }
        .onDisappear {
            saveChanges()
        }
    }
    
    private func saveChanges() {
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
        } catch {
            // Handle the error
            print("Error saving question: \(error)")
        }
    }
}

struct TeacherDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        let question = Question(context: dataController.container.viewContext)
        question.name = "Sirius Black"
        
        return QuestionDetailView(question: question)
    }
}
