//
//  ViewController.swift
//  ScriptHandler
//
//  Created by Chun-Li Cheng on 2021/12/14.
//

import UIKit
// 故事層
enum Section {
    case phase
}
// 旅程階段
struct Trip: Hashable {
//    let uuid = UUID()
//    private enum CodingKeys : String, CodingKey { case name }
    
    let name: String
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

}

//extension Trip: Hashable {
//    static func ==(lhs: Trip, rhs: Trip) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uuid)
//    }
//}

class PhaseCell: UITableViewCell {
    
}

class ViewController: UIViewController {
    lazy var tableView: UITableView = {
        var tbV = UITableView()
        tbV.translatesAutoresizingMaskIntoConstraints = false
        tbV.register(PhaseCell.self, forCellReuseIdentifier: "\(PhaseCell.self)")
        return tbV
    }()
    
    let trips = [
        Trip(name: "平凡世界"),
        Trip(name: "冒險的召喚"),
        Trip(name: "拒絕召喚"),
        Trip(name: "遇上師傅"),
        Trip(name: "跨越第一道門檻"),
        Trip(name: "試煉、盟友、敵人"),
        Trip(name: "進逼洞穴最深處"),
        Trip(name: "苦難折磨"),
        Trip(name: "獎賞（掌握寶劍）"),
        Trip(name: "歸返之路"),
        Trip(name: "復甦"),
        Trip(name: "帶著萬靈丹歸返")
    ]
    
    var dataSource: UITableViewDiffableDataSource<Section, Trip>!
    var tripSet = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PhaseCell.self)", for: indexPath) as? PhaseCell else {
                return UITableViewCell()
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.textLabel?.text = itemIdentifier.name
            cell.textLabel?.textColor = UIColor.random()
            
            return cell
        })

//        setupTrips()
        
        // 測試barItem的動作
        let leftBar = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(ReorderButtonClick))
        navigationItem.leftBarButtonItem = leftBar
        
    }
    // 測試barItem的動作
    @objc func ReorderButtonClick() {
//        tableView.setEditing(!tableView.isEditing, animated: true)
        
        let vc = SecondViewController()
        show(vc, sender: nil)
        
    }

    @objc func didTapAdd() {
        let acSheet = UIAlertController(title: "Select Trip State", message: nil, preferredStyle: .actionSheet)
        for index in 0..<trips.count {
            acSheet.addAction(UIAlertAction(title: trips[index].name, style: .default, handler: { [self]_ in
                if !tripSet.isEmpty {
                    for i in 0..<tripSet.count {
                        if tripSet[i].hashValue == trips[index].hashValue {
                            return
                        }
                    }
                }
                tripSet.append(self.trips[index])
                updateDataSource()
            }))
        }
        
        acSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(acSheet, animated: true, completion: nil)
       
    }
    
    private func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Trip>()
        snapShot.appendSections([.phase])
        snapShot.appendItems(tripSet, toSection: .phase)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .white
        setupNav()
        setupTableView()
    }
    private func setupNav() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "英雄的十二段旅程"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done, target: self, action: #selector(didTapAdd))
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.layer.cornerRadius = 10
    }
//    private func setupTrips() {
//    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trip = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print("\(trip.name) at \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    // 設定editingStyle, 如delete是左滑刪除的style
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
////        tableView.deleteRows(at: [indexPath], with: .fade)
////        tableView.reloadData()
//
////        tripSet.remove(at: indexPath.row)
////        updateDataSource()
//        if tableView.isEditing {
//            return .none
//        } else {
//            return .delete
//        }
//
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
//        }
//    }
    
    // 設定刪除詳細動作, 如刪除資料, 更新表格(但這裡可做更詳細動作, 便不需要style)
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let action = UITableViewRowAction(style: .default, title: "刪除") { ac, index in
//            self.tripSet.remove(at: index.row)
//            self.updateDataSource()
//
////            var snapShot = NSDiffableDataSourceSnapshot<Section, Trip>()
////            snapShot.deleteSections([.phase])
////            snapShot.deleteItems(self.tripSet)
////            self.dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
//            //            tableView.reloadData()
//        }
//        return [action]
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") { (ac, view, completionHandler) in
            self.tripSet.remove(at: indexPath.row)
            self.updateDataSource()
            
//            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let otherAction = UIContextualAction(style: .destructive, title: "另") { (ac, view, completionHandler) in

            completionHandler(true) // 採用方能在無動作時回彈
        }
        otherAction.backgroundColor = .systemBlue
        otherAction.image = UIImage(systemName: "pencil")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, otherAction])
        // 避免滑到底觸發第一個action
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
}

// 用以測試可移動的cellRow
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tripSet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let moveItem = tripSet[sourceIndexPath.row]
//        tripSet.remove(at: sourceIndexPath.row)
//        tripSet.insert(moveItem, at: destinationIndexPath.row)
      
        print(tripSet)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
//        return CGFloat(arc4random()) / CGFloat(UInt32.max)
        return CGFloat(random(in: 0...155)) / CGFloat(255)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}

