//
//  PrincipalDetailView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI

struct InterviewDetailView: View {
    
    let interview : Interview
    
    // The school, teachers and students objects are fetched from
    // within the principal object itself
    var session : Session? {
        interview.session
    }
    var question : [Question] {
        interview.session?.question?.allObjects as? [Question] ?? []
    }
    var response : [Response] {
        interview.session?.response?.allObjects as? [Response] ?? []
    }
    
    var body: some View {
        Form {
            Section (header: Text("Interview")) {
                List {
                    Text("\(interview.name ?? "")")
                }
            }
            Section (header: Text("Sessions")) {
                List {
                    Text("\(session?.name ?? "")")
                }
            }
            Section (header: Text("Questions")) {
                List {
                    ForEach(question) { question in
                        Text("\(question.name ?? "")")
                    }
                }
            }
            Section (header: Text("Responses")) {
                List {
                    ForEach(response) { response in
                        Text("\(response.name ?? "")")
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
