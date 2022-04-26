//
//  ViewTask.swift
//  PlanIt
//
//  Created by Ian Lockwood on 4/26/22.
//

import SwiftUI

struct ViewTask: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    var colors = ["Teal","Yellow","Pink"]
    var colorsColors = ["logoTeal","logoYellow","logoPink"]
    @State var savedColor: String = ""
    @State var savedColorName: String = ""
    
    
    var priorities = ["Urgent","Slightly Urgent","Not Urgent"]
    var priorityColors = ["priorityRed","priorityYellow","priorityGreen"]
    @State var savedPriority: String = ""
    @State var savedPriorityName: String = ""
    

    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Task Description")) {
                    HStack{
                        Label("Due Date", systemImage: "calendar")
                        Spacer()
                        Text("\(taskDate, formatter: dateFormatter)")
                    }
                    HStack {
                        Label("Priority", systemImage:"flag")
                        Spacer()
                        Text(savedPriority)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color(savedPriorityName))
                            .cornerRadius(5)
                    }
                    HStack {
                        Label("Theme", systemImage:"paintpalette")
                        Spacer()
                        Text(savedColor)
                            .padding(5)
                            .foregroundColor(.black)
                            .background(
                                Color(savedColorName)
                            )
                            .cornerRadius(5)
                    }
                }
                Section(header: Text("Task Description")) {
                    HStack {
                        Text(taskDescription)
                    }
                }
                Section(header: Text("Task Notes")) {
                    HStack {
                        NavigationLink(destination: NewNote()) {
                            Label("Take a note", systemImage: "note")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(taskTitle)
            // MARK: Action Buttons
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
                
            }
            
            .onAppear {
                if let task = taskModel.viewTask{
                    taskTitle = task.taskTitle ?? ""
                    taskDate = task.taskDate ?? Date()
                    taskDescription = task.taskDescription ?? ""
                    savedColor = task.savedColor ?? ""
                    savedPriority = task.savedPriority ?? ""
                    savedColorName = task.savedColorName ?? ""
                    savedPriorityName = task.savedPriorityName ?? ""

                }
            }
            
        }
        
    }
    
}


