//
//        .........     .........
//      ......  ...........  .....
//      ...        .....       ....
//     ...         ....         ...
//     ...       ........        ...
//     ....      .... ....      ...
//      ...      .... ....      ...
//      .....     .......     ....
//        ...      .....     ....
//         ....             ....
//           ....         ....
//            .....     .....
//              .....  ....
//                .......
//                  ...

import CustomTabBar
import NetworkStack
import Reactor
import SwiftyBeaver
import UIKit

final class CustomTabBarController: UITabBarController {
    
    enum Tab: Int {
        case list
        case groups
        case drawName
        case settings
        
        var dataObject: TabDataObject {
            switch self {
            case .list:
                return TabDataObject(title: NSLocalizedString("List", comment: ""), image: UIImage(named: "lists"))
            case .groups:
                return TabDataObject(title: NSLocalizedString("Groups", comment: ""), image: UIImage(named: "groups"))
            case .drawName:
                return TabDataObject(title: NSLocalizedString("Draw names", comment: ""), image: UIImage(named: "challenges"))
            case .settings:
                return TabDataObject(title: NSLocalizedString("Settings", comment: ""), image: UIImage(named: "settings"))
            }
        }
        
        static let allValues = [Tab.list, .groups, .drawName, .settings]
    }
    
    
    // MARK: - Public properties

    @IBOutlet var customTabBar: CustomTabBar!
    
    var core = App.core
    fileprivate let tabBarHeight: CGFloat = 48.0
    
    
    // MARK: - Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupTabBar()
        displayCustomTabBar()
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


// MARK: - Custom tab bar delegate

extension CustomTabBarController: CustomTabBarDelegate, AutoStoryboardInitializable {
    
    func tabBar(_ tabBar: CustomTabBar, didSelectTab tab: Int) {
        if let selectedNav = selectedViewController as? UINavigationController , tab == selectedIndex {
            selectedNav.popToRootViewController(animated: true)
        } else {
            selectedIndex = tab
        }
    }
    
}

extension CustomTabBarController: Reactor.Subscriber {
    
    func update(with state: AppState) {
    }
    
}


// MARK: - Private functions

private extension CustomTabBarController {
    
    func setupTabBar() {
        let allDataObjects = Tab.allValues.map { $0.dataObject }
        customTabBar.titleFont = UIFont.appFont(10)
        customTabBar.dataObjects = allDataObjects
        tabBar.isHidden = true
    }
    
    func setupViewControllers() {
        let goalViewController = 
        let eventViewController = EventListViewController.initializeFromStoryboard()
        let groupsViewController = GroupListViewController.initializeFromStoryboard()
        let challengesViewController = ChallengeListViewController.initializeFromStoryboard()
        let settingsViewController = SettingsTableViewController.initializeFromStoryboard()
        viewControllers = [goalViewController, eventViewController, groupsViewController, challengesViewController, settingsViewController]
    }
    
    func displayCustomTabBar() {
        view.addSubview(customTabBar)
        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}
