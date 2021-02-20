##  Questions

1- Added a searchbar, what would you think would be a good exercise to abstract "SearchBarView" and not passing "ToDo" and do it more generic? Maybe using protocols?
I tried myself (Adding a Searchable Protocol where ToDo conforms it) but I can't automatically transform it 
Cannot convert value of type 'Binding<[ToDo]>'(in the TodoListView) to expected argument type 'Binding<[Searchable]>'(in SearchBarView). I attached an screenshot in github.

## Ideas for next iterations
0. Add a search bar in the main list to being able to search for both todos and categories.
1. Sorting (by due date, by category, etc.)
2. Do migrations. Priority from 0 (low) 1(med) 2(high) to its own entity with priority and color associated.
3. Do an importer from a json in background
4. Create a little framework for the app. (maybe extracting coredata? I would like to start as simple as possible so maybe...)
5. Hability to mark items as done
6. Any usecase for use DispatchSemaphore

