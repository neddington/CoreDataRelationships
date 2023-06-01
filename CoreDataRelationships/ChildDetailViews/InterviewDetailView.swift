//
//  InterviewDetailView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

struct InterviewDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var interview: Interview
    
    @State private var interviewName: String
    
    init(interview: Interview) {
        self.interview = interview
        _interviewName = State(initialValue: interview.name ?? "")
    }
    
    var questions: [Question] {
        interview.questionInterviews?.compactMap { ($0 as? QuestionInterview)?.question } ?? []
    }
    
    var body: some View {
        Form {
            Section(header: Text("Interview")) {
                List {
                    TextField("Interview Name", text: $interviewName)
                        .onAppear {
                            self.interviewName = interview.name ?? ""
                        }
                }
            }
            Section(header: Text("Questions")) {
                List {
                    ForEach(questions) { question in
                        Text("\(question.name ?? "")")
                    }
                }
            }
        }
        .navigationTitle("Interview")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: interviewName) { newValue in
            interview.name = newValue
            saveChanges()
        }
        .onReceive(interview.objectWillChange) { _ in
            interviewName = interview.name ?? ""
        }
    }
    
    private func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Failed to save changes: \(error)")
        }
    }
}

struct InterviewDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        let interview = Interview(context: dataController.container.viewContext)
        interview.name = "Dolores Umbridge"
        
        return InterviewDetailView(interview: interview)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
