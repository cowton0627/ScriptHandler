//
//  SecondViewController.swift
//  ScriptHandler
//
//  Created by Chun-Li Cheng on 2021/12/15.
//

import UIKit

enum Gender {
    case Male
    case Female
}

struct Person {
    let name: String
    let gender: Gender
}

struct StoryState {
    let description: String
}

class SecondCell: UITableViewCell {
    
}

class SecondViewController: UIViewController {
    lazy var myTableView: UITableView = {
        let table = UITableView()
        table.register(SecondCell.self, forCellReuseIdentifier: "\(SecondCell.self)")
        return table
    }()
    
    var personInfos = [
        Person(name: "Charles", gender: .Male),
        Person(name: "John", gender: .Male),
        Person(name: "Jean", gender: .Female),
        Person(name: "Cherry", gender: .Female),
        Person(name: "Shawn", gender: .Male),
        Person(name: "Lily", gender: .Female),
        Person(name: "Carlos", gender: .Male)
    ]
    
    var storyStates = [
        StoryState(description: "倒下的她"),
        StoryState(description: "在離城堡有點遠的森林裡"),
        StoryState(description: "此時小矮人們剛砍完柴"),
        StoryState(description: "於回家路上遇到"),
        StoryState(description: "皇后便消失了"),
        StoryState(description: "說服公主吃下蘋果後")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "試煉、盟友、敵人"
        view.addSubview(myTableView)
        myTableView.frame = view.bounds
        myTableView.dataSource = self
        myTableView.delegate = self
        
        let rightBar = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(buttonTapped))
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc func buttonTapped() {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
    }

}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        personInfos.count
        storyStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SecondCell.self)", for: indexPath) as? SecondCell else {
            return UITableViewCell()
        }
//        let info = personInfos[indexPath.row]
//        cell.textLabel?.text = info.name
        let storyState = storyStates[indexPath.row]
        cell.textLabel?.text = storyState.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedItem = personInfos[sourceIndexPath.row]
//        personInfos.remove(at: sourceIndexPath.row)
//        personInfos.insert(movedItem, at: destinationIndexPath.row)
        let moveLine = storyStates[sourceIndexPath.row]
        storyStates.remove(at: sourceIndexPath.row)
        storyStates.insert(moveLine, at: destinationIndexPath.row)
    }
    
    
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}
