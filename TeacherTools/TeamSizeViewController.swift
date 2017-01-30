//
//  TeamSizeViewController.swift
//  TeacherTools
//
//  Created by Parker Rushton on 11/6/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

class TeamSizeViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var core = App.core
    var maxSize = 4
    var currentSize = 2
    let cellId = "NumberCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        core.remove(subscriber: self)
    }

}


// MARK: - Subscriber

extension TeamSizeViewController: Subscriber {

    func update(with state: AppState) {
        guard let selectedGroup = state.selectedGroup else { return }
        currentSize = selectedGroup.teamSize
        maxSize = selectedGroup.studentIds.count / 2
        tableView.reloadData()
        preferredContentSize = CGSize(width: 200, height: tableView.contentSize.height + 44)
        updateUI(with: state.theme)
    }
    
    func updateUI(with theme: Theme) {
        backgroundImageView.image = theme.mainImage.image
        topLabel.font = theme.font(withSize: topLabel.font.pointSize)
        topLabel.textColor = theme.textColor
    }

}


extension TeamSizeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxSize > 2 ?  maxSize - 1 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let sizeForRow = indexPath.row + 2
        cell.textLabel?.text = "\(sizeForRow)"
        cell.textLabel?.font = core.state.theme.font(withSize: cell.textLabel?.font.pointSize ?? 30)
        let sizeIsCurrentlySelected = core.state.selectedGroup!.teamSize == sizeForRow
        cell.textLabel?.textColor = sizeIsCurrentlySelected ? core.state.theme.tintColor : core.state.theme.textColor
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        core.fire(command: UpdateTeamSize(size: indexPath.row + 2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

}
