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
