//
//  TeacherDetailView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 29/03/22.
//

import SwiftUI

struct QuestionDetailView: View {
    
    let question : Question
        
    //The school, principal and students objects are fetched from the teacher object
    var session : Session? {
        question.session
    }
    var interview : Interview? {
        question.interview
    }
    var response : [Response] {
        question.response?.allObjects as? [Response] ?? []
    }
    
    var body: some View {
        Form {
            Section (header: Text("Name")) {
                List {
                    Text(question.name ?? "")
                }
            }
            Section (header: Text("School")) {
                List {
                    Text(session?.name ?? "")
                }
            }
            Section (header : Text ("Principal")) {
                List {
                    Text (interview?.name ?? "")
                }
            }
            Section (header: Text("Students")) {
                List {
                    ForEach (response) { name in
                        Text(name.name ?? "")
                    }
                }
            }
        }
        .navigationTitle("Teacher")
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
