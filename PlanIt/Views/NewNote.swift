//
//  NewNote.swift
//  PlanIt
//
//  Created by Ian Lockwood on 4/26/22.
//

import SwiftUI

struct NewNote: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel
    
    @State var noteNotes: String = ""
    @State var noteTitle: String = ""
    
    var body: some View {
            List {
                Section(header: Text("Notes")) {
                    TextField("Title", text: $noteTitle)
                    TextEditor(text: $noteNotes)
                        .lineLimit(25)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
            }
            .onDisappear {
              
                
            }
    }
    
}

