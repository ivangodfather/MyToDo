//
//  ImporterResponse.swift
//  MyToDo
//
//  Created by Ivan Ruiz Monjo on 6/3/21.
//

import Foundation

struct ToDoResponse {
	let title: String
	let date: Date
	let priority: Int
	let attachment: URL? //
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func remoteResponse() -> [ToDoResponse] {

	(1...50).map { i -> ToDoResponse in
		let todoResponse = ToDoResponse(title: "\(i) " + randomString(length: 4),
										date: Date(),
										priority: Int.random(in: 0...2),
										attachment: URL(string: "https://source.unsplash.com/random/2000x2000?sig=\(Int.random(in: 1...10000))"))
		return todoResponse
	}
}

extension CoreDataStorage {
	func importFromResponse(_ items: [ToDoResponse]) {
		print("STARTING IMPORTING")
		let bgContext =  persistentContainer.newBackgroundContext()
		let group = DispatchGroup()
		items.enumerated().forEach { index, todoResponse in
			group.enter()
			bgContext.perform {
				let todo = ToDo(context: bgContext)
				todo.title = todoResponse.title
				todo.dueDate = todoResponse.date
				todo.priority = Priority.getPriority(from: todoResponse.priority, usingContext: bgContext)
				let categories = CoreDataStorage.shared.items(entity: Category.self, context: bgContext )
				if let random = try? categories.get().randomElement() {
					todo.category = random
				} else {
					let randomCat = Category(context: bgContext)
					randomCat.title = "My random cat"
					randomCat.imageName = "person.and.arrow.left.and.arrow.right"
				}
				let attachment = Attachment(context: bgContext)
				URLSession.shared.dataTask(with: todoResponse.attachment!) { (data, _, _) in
					bgContext.perform {
						attachment.image = data
						attachment.todo = todo
						print("download asset for \(index)")
						group.leave()
					}

				}.resume()
			}
		}
		group.notify(queue: DispatchQueue.global(qos: .background)) {
			bgContext.perform {
				print("finished")
				try! bgContext.save()
			}
		}
	}
}

