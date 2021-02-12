##  Questions

1. In CoreDataStorage, what would be a better approax to not have such a convoluted file dealing with ToDos (insert, delete, update...), Categories and future Entities?

2. In the current approax I create new ToDo and Category separately
```swift 
func addToDo(title: String, dueDate: Date, category: Category) -> ToDo
func addCategory(title: String, imageName: String) -> Category
```
I can do this since the relationship between both is optional.
If this would not have been optional (maybe it should be?), what would be your approax to avoid have such long signature (especially in the future) with so many params like this?
`func addToDo(title: String, dueDate: Date, category: Category, catTitle: String, catImageName: String) -> ToDo`
Would you create those entities in the view and just call .save in Coredata?

3. On AddTodoView I have an state that is when the item is saved. On the view at first I wrote this
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

## Ideas for next iterations
0. Add a search bar in the main list to being able to search for both todos and categories.
1. Sorting (by due date, by category, etc.)
2. Do migrations. Priority from 0 (low) 1(med) 2(high) to its own entity with priority and color associated.
3. Do an importer from a json in background
4. Create a little framework for the app. (maybe extracting coredata? I would like to start as simple as possible so maybe...)
5. Hability to mark items as done

