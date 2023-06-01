//
//  TeacherDetailView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

struct QuestionDetailView: View {
    let question: Question
    
    var session: Session? {
        question.session
    }
    var interviews: [Interview] {
        question.questionInterviews?.compactMap { ($0 as? QuestionInterview)?.interview } ?? []
    }
    var response: [Response] {
        question.response?.allObjects as? [Response] ?? []
    }
    
    var body: some View {
        Form {
            Section(header: Text("Question")) {
                List {
                    Text(question.name ?? "")
                }
            }
            Section(header: Text("Session")) {
                List {
                    Text(session?.name ?? "")
                }
            }
            Section(header: Text("Interviews")) {
                List {
                    ForEach(interviews) { interview in
                        Text(interview.name ?? "")
                    }
                }
            }
            Section(header: Text("Response")) {
                List {
                    ForEach(response) { name in
                        Text(name.name ?? "")
                    }
                }
            }
        }
        .navigationTitle("Question")
        .navigationBarTitleDisplayMode(.inline)
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
