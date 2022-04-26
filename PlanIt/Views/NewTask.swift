//
//  NewTask.swift
//  PlanIt
//
//  Created by Ian Lockwood on 4/26/22.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    
    var colors = ["Teal","Yellow","Pink"]
    @State var selectedColor: Int = 0
    var colorsColors = ["logoTeal","logoYellow","logoPink"]
    @State var savedColor: String = ""
    @State var savedColorName: String = ""
    
    
    var priorities = ["Urgent","Slightly Urgent","Not Urgent"]
    @State var selectedPriority: Int = 0
    var priorityColors = ["priorityRed","priorityYellow","priorityGreen"]
    @State var savedPriority: String = ""
    @State var savedPriorityName: String = ""
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel
    var body: some View {
        
        NavigationView{
            List{
                Section {
                    TextField("Go to work", text: $taskTitle)
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(0..<priorities.count){
                            Text(priorities[$0])
                        }
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color(priorityColors[selectedPriority]))
                        .cornerRadius(5)
                        
                    }
                    Picker("Theme", selection: $selectedColor) {
                        ForEach(0..<colors.count){
                            Text(colors[$0])
                        }
                        .padding(5)
                        .foregroundColor(.black)
                        .background(Color(colorsColors[selectedColor]))
                        .cornerRadius(5)
                    }
                } header: {
                    Text("Task Information")
                }

                Section {
                    TextEditor(text: $taskDescription)
                } header: {
                    Text("Task Description")
                }
                
                // Disabling Date for Edit Mode
                if taskModel.editTask == nil{
                    
                    Section {
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Task Date")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: Disbaling Dismiss on Swipe
            .interactiveDismissDisabled()
            // MARK: Action Buttons
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        
                        if let task = taskModel.editTask{
                            
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.savedColor = String("\(colors[selectedColor])")
                            task.savedPriority = String("\(priorities[selectedPriority])")
                            task.savedColorName = String("\(colorsColors[selectedColor])")
                            task.savedPriorityName = String("\(priorityColors[selectedPriority])")
                        }
                        else{
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                            task.savedColor = String("\(colors[selectedColor])")
                            task.savedPriority = String("\(priorities[selectedPriority])")
                            task.savedColorName = String("\(colorsColors[selectedColor])")
                            task.savedPriorityName = String("\(priorityColors[selectedPriority])")
                        }
                        
                        // Saving
                        try? context.save()
                        // Dismissing View
                        dismiss()
                    }

                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            // Loading Task data if from Edit
            .onAppear {
                if let task = taskModel.editTask{
                    taskTitle = task.taskTitle ?? ""
                    taskDescription = task.taskDescription ?? ""
                }
            }
        }
    }
    
}
