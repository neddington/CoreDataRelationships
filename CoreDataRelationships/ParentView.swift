//
//  ContentView.swift
//  CoreDataRelationships
//
//  Created by Sahil Satralkar on 22/03/22.
//

import SwiftUI
import CoreData

struct ParentView: View {
    @EnvironmentObject var dataController : DataController
    
    let session : FetchRequest<Session>
    
    @State var showingAddSession : Bool = false
    
    init(){
        session = FetchRequest<Session>(entity: Session.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: false)])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    List {
                        ForEach(session.wrappedValue) { session in
                            NavigationLink (destination: DetailView(session: session )){
                                VStack(alignment: .leading) {
                                    Text(session.name ?? "").font(.headline)
                                    Spacer()
                                }.padding()
                            }
                        }
                        .onDelete(perform: deleteSession)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Sample Data") {
                        dataController.createSampleData()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showingAddSession = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSession) {
                AddNewSessionView()
            }
        }
    }
    
    func deleteSession( at offsets : IndexSet) {
        for offset in offsets {
            let session = session.wrappedValue[offset]
                dataController.delete(session)
            }
            dataController.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        
         ParentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
