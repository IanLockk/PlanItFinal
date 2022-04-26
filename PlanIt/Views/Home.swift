//
//  Home.swift
//  PlanIt
//
//  Created by Ian Lockwood on 4/26/22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    // MARK: Edit Button Context
    @Environment(\.editMode) var editButton
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10){
                            
                            ForEach(taskModel.currentWeek,id: \.self){day in
                                
                                VStack(spacing: 10){
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                    
                                    // EEE will return day as MON,TUE,....etc
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 18))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 12, height: 12)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 60, height: 120)
                                .background(
                                
                                    ZStack{
                                        // MARK: Matched Geometry Effect
                                        if taskModel.isToday(date: day){
                                            Capsule()
                                                .fill(
                                                            LinearGradient(gradient: Gradient(colors: [Color("logoYellow"), Color("logoPink")]),
                                                                           startPoint: .top,
                                                                           endPoint: .bottom))
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation{
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        // MARK: Add Button
        .overlay(
        
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("logoTeal"), Color("logoPink")]),
                                               startPoint: .top,
                                               endPoint: .bottom), in: Circle())
                
            })
            .padding()
            
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            // Clearing Edit Data
            taskModel.editTask = nil
        } content: {
            NewTask()
                .environmentObject(taskModel)
        }
        
        .sheet(isPresented: $taskModel.viewTaskBool) {

        } content: {
            ViewTask()
                .environmentObject(taskModel)
        }


    }
    
    
    // MARK: Tasks View
    @ViewBuilder
    func TasksView()->some View{
        
        LazyVStack(spacing: 10){
                // Converting object as Our Task Model
                DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                        TaskCardView(task: object)
                }
            }
            .padding()
            .padding(.top)
    }
    
    // MARK: Task Card View
    @ViewBuilder
    func TaskCardView(task: Task)->some View{
        
        // MARK: Since CoreData Values will Give Optinal data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top,spacing: 30){
            
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active{
                
                // Edit Button for Current and Future Tasks
                VStack(spacing: 20){
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        // MARK: Deleting Task
                        context.delete(task)
                        
                        // Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }else{
                
            }
            
            Button(action: {
                taskModel.viewTask = task
                taskModel.viewTaskBool.toggle()
            }) { VStack{
                VStack{
                    HStack(alignment: .top, spacing: 5) {
                        
                        VStack(alignment: .leading, spacing: 7) {
                            HStack {
                                Image(systemName: "flag")
                                    .padding(5.5)
                                    .foregroundColor(.black)
                                    .background(Color(task.savedPriorityName!),in: Circle())
                                Text(task.taskTitle ?? "")
                                    .font(.title)
                            }
                            Text(task.taskDescription ?? "")
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .hLeading()
                        
                        

                    }
                    
                    
                    HStack(spacing: 7.5){
      
                        // MARK: Check Button
                        if !task.isCompleted{
                                
                            Button {
                                // MARK: Updating Task
                                task.isCompleted = true
                                    
                                // Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(7.5)
                                    .background(Color.white,in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                            
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .black)
                            .hLeading()
                    }
                }
                .frame(width: 270, height: 125)
            }
            .frame(width: 300, height: 150)
            .foregroundColor(.black)
            .padding(0)
            .padding(.bottom, 10)
            .hLeading()
            .background(
                Color(task.savedColorName!)
                    .cornerRadius(25)
                    .opacity(1)
            )
        }
        .hLeading()
        }
    }
    
    // MARK: Header
    func HeaderView()->some View{
        
        HStack(spacing: 10){
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("My Tasks")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            // MARK: Edit Button
            EditButton()
                .font(.title2)
        }
        .padding()
        .padding(.top,getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: UI Design Helper functions
extension View{
    
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .trailing)
    }
    
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}
