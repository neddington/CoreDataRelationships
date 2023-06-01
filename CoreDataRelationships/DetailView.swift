//
//  DetailView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 26/03/22.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let session : Session
    
    var question : [Question]
    
    var response : [Response]
    
    var interview : [Interview] = []
    
    @State private var showingAddPrincipal : Bool = false
    @State private var showingAddTeacher : Bool = false
    @State private var showingAddStudent : Bool = false
    
    init(session : Session) {
        self.session = session
        
        self.question  = session.question?.allObjects as! [Question]
        self.question = self.question.sorted(by: {$0.date! < $1.date!})
        
        
        self.response = session.response?.allObjects as! [Response]
        self.response = self.response.sorted(by: {$0.date! < $1.date!})
        
        if let prin = session.interview {
            self.interview.append(prin)
        }
    }
    
    var body: some View {
        Form {
            Section (header: Text("Interview")) {
                List {
                    ForEach(interview) { princ in
                        NavigationLink  {
                            InterviewDetailView(interview: princ)
                        } label: {
                            Label(session.interview?.name ?? "", systemImage: "star.fill")
                        }
                    }
                    .onDelete(perform: deleteInterview)
                    Button  {
                        self.showingAddPrincipal = true
                    } label: {
                        Text("Add Interview")
                    }
                }
             }
            Section (header: Text("Questions")) {
                List {
                    ForEach(question) { question in
                        NavigationLink {
                            QuestionDetailView(question: question)
                        } label: {
                            Label(question.name ?? "", systemImage: "bolt.fill")
                        }
                    }
                    .onDelete(perform: deleteQuestion)
                    Button  {
                        self.showingAddTeacher = true
                    } label: {
                        Text("Add Question")
                    }
                }
            }
            Section (header: Text("Response")) {
                List {
                    ForEach(response) { response in
                        NavigationLink {
                            ResponseDetailView(response: response)
                        } label: {
                            Label(response.name ?? "", systemImage: "heart.fill")
                        }
                    }
                    .onDelete(perform: deleteResponse)
                    Button  {
                        self.showingAddStudent = true
                    } label: {
                        Text("Add Response")
                    }
                }
            }
        }
        .navigationTitle(Text("Details"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddPrincipal) {
            AddNewInterviewView(session: self.session)
        }
        .sheet(isPresented: $showingAddTeacher) {
            AddNewQuestionView(session: self.session)
        }
        .sheet(isPresented: $showingAddStudent) {
            AddNewResponseView(session: self.session)
        }
    }
    
    //Function to remove individual items    
    func deleteQuestion( at offsets : IndexSet) {
        for offset in offsets {
                let question = question[offset]
                dataController.delete(question)
            }
            dataController.save()
    }
    
    func deleteResponse( at offsets : IndexSet) {
        for offset in offsets {
                let response = response[offset]
                dataController.delete(response)
            }
            dataController.save()
    }
    
    func deleteInterview( at offsets : IndexSet) {
        for offset in offsets {
                let princi = interview[offset]
                dataController.delete(princi)
            }
            dataController.save()
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        let session = Session(context: dataController.container.viewContext)
        
        return DetailView(session: session)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
