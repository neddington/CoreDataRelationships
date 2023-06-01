//
//  ContentView.swift
//  CoreDataRelationships
//
//  Created by Nick Eddington.
//

import SwiftUI
import CoreData

struct ParentView: View {
    @EnvironmentObject var dataController : DataController

    let session: FetchRequest<Session>
    
    @State private var showingAddSession = false
    @State private var sessionName = ""
    @State private var interviewID = 0
    let interviewsFetchRequest = FetchRequest<Interview>(entity: Interview.entity(), sortDescriptors: [])

    init() {
        session = FetchRequest<Session>(entity: Session.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: false)])
    }

    var body: some View {
        NavigationView {
            VStack {
                Section {
                    List {
                        ForEach(session.wrappedValue) { session in
                            NavigationLink(destination: DetailView(session: session)) {
                                VStack(alignment: .leading) {
                                    Text(session.name ?? "").font(.headline)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .onDelete(perform: deleteSession)
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()

                Button {
                    showingAddSession = true
                } label: {
                    Text("Add New Session")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(25)
                }
                .sheet(isPresented: $showingAddSession) {
                    VStack {
                        Text("Session Configuration")
                            .font(.title)
                        TextField("Session Name", text: $sessionName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .padding(.top)
                            .autocorrectionDisabled()

                        List {
                            ForEach(interviewsFetchRequest.wrappedValue) { interview in
                                HStack {
                                    Text(interview.name ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: interviewID == interviewsFetchRequest.wrappedValue.firstIndex(of: interview) ? "button.programmable" : "circle")
                                        .frame(alignment: .trailing)
                                        .foregroundColor(interviewID == interviewsFetchRequest.wrappedValue.firstIndex(of: interview) ? Color.accentColor : Color.black)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    interviewID = interviewsFetchRequest.wrappedValue.firstIndex(of: interview) ?? 0
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Sample Data") {
                        dataController.createSampleData()
                    }
                }
            }
        }
    }

    func deleteSession(at offsets: IndexSet) {
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
