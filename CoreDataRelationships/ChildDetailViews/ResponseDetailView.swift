//
//  StudentDetailView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 29/03/22.
//

import SwiftUI

struct ResponseDetailView: View {
    
    let response : Response
    
    // The school, principal and teachers objects are fetched from
    // the student object itself
    var session : Session? {
        response.session
    }
    var interview : Interview? {
        response.interview
    }
    var question : [Question] {
        response.question?.allObjects as? [Question] ?? []
    }
    
    var body: some View {
        Form {
            Section (header: Text("Name")){
                List {
                    Text(response.name ?? "")
                }
            }
            Section (header : Text("School")) {
                List {
                    Text (session?.name ?? "")
                }
            }
            Section (header: Text("Principal")) {
                List {
                    Text (interview?.name ?? "")
                }
            }
            Section (header : Text ("Teachers")) {
                List {
                    ForEach (question) { question in
                        Text(question.name ?? "")
                    }
                }
            }
        }
        .navigationTitle("Response")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResponseDetailView_Previews: PreviewProvider {
    
    static let dataController = DataController.preview
    
    static var previews: some View {
        let response = Response(context: dataController.container.viewContext)
        response.name = "Cedric Diggory"
        return ResponseDetailView(response: response)
    }
}
