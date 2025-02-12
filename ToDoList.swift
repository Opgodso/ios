import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var details: String
    var dueDate: Date
    var isCompleted: Bool = false
}

struct ContentView: View {
    @State private var todoItems: [TodoItem] = []
    @State private var newTodoTitle: String = ""
    @State private var newTodoDetails: String = ""
    @State private var newTodoDueDate: Date = Date()
    @State private var showAddTaskSheet: Bool = false
    @State private var filterText: String = ""
    @State private var editingIndex: Int? = nil
    @State private var editingText: String = ""

    var filteredItems: [TodoItem] {
        if filterText.isEmpty {
            return todoItems
        } else {
            return todoItems.filter { $0.title.localizedCaseInsensitiveContains(filterText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredItems) { item in
                        let index = todoItems.firstIndex(where: { $0.id == item.id })!
                        HStack {
                            Toggle(isOn: Binding(
                                get: { todoItems[index].isCompleted },
                                set: { todoItems[index].isCompleted = $0 }
                            )) {
                                VStack(alignment: .leading) {
                                    Text(todoItems[index].title)
                                        .strikethrough(todoItems[index].isCompleted, color: .gray)
                                        .foregroundColor(todoItems[index].isCompleted ? .gray : (isOverdue(todoItems[index].dueDate) ? .red : .black))
                                        .onTapGesture {
                                            editTaskTitle(at: index)
                                        }
                                    Text(todoItems[index].details)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("Due: \(formattedDate(todoItems[index].dueDate))")
                                        .font(.caption)
                                        .foregroundColor(isOverdue(todoItems[index].dueDate) ? .red : .gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showAddTaskSheet.toggle()
                    }) {
                        Text("Add Task")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    TextField("Filter tasks", text: $filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
            }
            .sheet(isPresented: $showAddTaskSheet) {
                VStack {
                    Text("Add a New Task")
                        .font(.headline)
                        .padding()

                    TextField("Enter task name", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Enter task details", text: $newTodoDetails)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    DatePicker("Select due date", selection: $newTodoDueDate, displayedComponents: .date)
                        .padding()

                    Button(action: {
                        addTodo()
                        showAddTaskSheet = false
                    }) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }

    func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todoItems.append(TodoItem(title: newTodoTitle, details: newTodoDetails, dueDate: newTodoDueDate))
        newTodoTitle = ""
        newTodoDetails = ""
        newTodoDueDate = Date()
    }

    func deleteTodo(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }

    func isOverdue(_ date: Date) -> Bool {
        date < Date()
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func editTaskTitle(at index: Int) {
        let newTitle = "Edited Task"
        todoItems[index].title = newTitle
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
