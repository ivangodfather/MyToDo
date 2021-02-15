##  Questions

1. In CoreDataStorage.swift, what would be a better approax to not have such a convoluted file dealing with ToDos (insert, delete, update...), Categories and future Entities?


2. On AddTodoView I have an state that is when the item is saved. On the view at first I wrote this
```case .saved(let todo):
    Text(todo.title ?? "")
        .onAppear { presentationMode.wrappedValue.dismiss() }
}
```
So the idea is when my viewmodel informs me that the item is saved I want to exit the view, but that does not seem particulary right.
I endup changing that to 
```
.onReceive(viewModel.$state, perform: { state in
    if case .saved(_) = state {
        presentationMode.wrappedValue.dismiss()
    }
})
```
What are your thoughts on that? Thinking again about it, both seems right to me, the first one would be nice to show something in the view before dismissing
```case .saved(let todo):
    TellTheItemHasCorrectlySaveView()
        .onAppear { delay(2) { presentationMode.wrappedValue.dismiss() } }
}
```
3. Would you recommend make everything in this protocol asynchronous?
```
protocol Storage {
    func save()
    func delete(object: Any)
    func getToDos() -> [ToDo]
    func addToDo(title: String, dueDate: Date, category: Category) -> ToDo
    func deleteToDos(indexSet: IndexSet)
    func getCategories() -> [Category]
    func addCategory(title: String, imageName: String) -> Category
}
```
Using Coredata with viewContext makes everything continuos, but, if for example I start using a backgroundContext I would have to change the signature, or any other storage framework like Realm
So would It be better to keep those usually "expensive" task with async signatures? like `func getToDos() -> AnyPublisher<[ToDo]>`

## Ideas for next iterations
0. Add a search bar in the main list to being able to search for both todos and categories.
1. Sorting (by due date, by category, etc.)
2. Do migrations. Priority from 0 (low) 1(med) 2(high) to its own entity with priority and color associated.
3. Do an importer from a json in background
4. Create a little framework for the app. (maybe extracting coredata? I would like to start as simple as possible so maybe...)
5. Hability to mark items as done
6. Any usecase for use DispatchSemaphore

