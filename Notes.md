##  Questions
1- Can we do this as an exercise?
So adding a non-optional attribute to ToDo, having to perform a migration.
Do migrations. Priority from 0 (low) 1(med) 2(high) to its own entity with priority and color associated.

2- I want to pass the filters from the view to the viewModel. Initially my idea was:
struct FiltersView: View {
 @EnvironmentObject var filters: TodoFilter
  @State var viewModel: FiltersViewModel
    init() {
       viewModel = _viewModel = State(wrappedValue: FiltersViewModel(filters: filters)) // I can't get them here since self has not been initialized
    }
}
}
I endedup passing it into the viewModel on onAppear (FilterView / FilterViewModel).
I know if I use coredata I could grab those filters easily using CoreDataStorage inside the viewModel, but the way I did, would you approach it differently?
In short, when I start the app I create a "Filter" struct that I'm passing into the view tree using EnvironmentObject. But I need this object inside the viewModel.
When I create viewmodels I'm inside init of the view, but its not yet initialized and I can't access self (EnvironmentObjects) yet.

3- Would you consider adding searchText as a filter and add it to ToDoFilter?



## Ideas for next iterations
0. Add new attribute (optional image) to work with Transformables
1. Sorting (by due date, by category, etc.)
2. Do migrations. Priority from 0 (low) 1(med) 2(high) to its own entity with priority and color associated.
3. Do an importer from a json in background
4. Create a little framework for the app. (maybe extracting coredata? I would like to start as simple as possible so maybe...)
5. Hability to mark items as done
6. Any usecase for use DispatchSemaphore


## Done
- Add a search bar in the main list to being able to search for both todos and categories.
