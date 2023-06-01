//
//  PrincipalDetailView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

struct InterviewDetailView: View {
    let interview: Interview
    
    var questions: [Question] {
        interview.questionInterviews?.compactMap { ($0 as? QuestionInterview)?.question } ?? []
    }
    
    var body: some View {
        Form {
            Section(header: Text("Interview")) {
                List {
                    Text("\(interview.name ?? "")")
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
    }
}

struct InterviewDetailView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        let interview = Interview(context: dataController.container.viewContext)
        interview.name = "Dolores Umbridge"
        
        return InterviewDetailView(interview: interview)
    }
}
