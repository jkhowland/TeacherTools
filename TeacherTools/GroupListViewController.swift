//
//  GroupListViewController.swift
//  TeacherTools
//
//  Created by Parker Rushton on 10/30/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController, AutoStoryboardInitializable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    var core = App.core
    var groups: [Group] {
        return core.state.groups.sorted { $0.lastViewDate < $1.lastViewDate }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        core.remove(subscriber: self)
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    func loadTestData() {
        core.fire(command: LoadFakeUser())
        core.fire(command: LoadFakeStudents())
        core.fire(command: LoadFakeGroups())
    }

}


// MARK: - Subscriber

extension GroupListViewController: Subscriber {
    
    func update(with state: AppState) {
        tableView.reloadData()
    }
    
}

extension GroupListViewController {
    
    func setUp() {
        tableView.rowHeight = 80.0
        plusButton.tintColor = core.state.theme.tintColor
        
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 3
        gr.addTarget(self, action: #selector(loadTestData))
        navigationController?.navigationBar.addGestureRecognizer(gr)
    }
    
}


// MARK: - TableView

extension GroupListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier) as! GroupTableViewCell
        cell.update(with: groups[indexPath.row], theme: core.state.theme)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        core.fire(event: Selected<Group>(groups[indexPath.row]))
        let toolsVC = ToolsViewController.initializeFromStoryboard()
        navigationController?.pushViewController(toolsVC, animated: true)
    }
    
}
