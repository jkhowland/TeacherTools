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

import UIKit

class MainViewController: UIViewController {

    var core = App.core
    
    let tabBarViewController = CustomTabBarController.initializeFromStoryboard()
    fileprivate let loadingImageVC = LoadingImageViewController.initializeFromStoryboard()

    
    fileprivate var needsInitialLoading = true
    
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


extension MainViewController: Subscriber {
    
    func update(with state: AppState) {
        if let _ = state.currentUser, state.groupsAreLoaded {
            presentApplication()
        } else {
            showLoadingScreen()
        }
    }
    
}


extension MainViewController {
    
    fileprivate func presentApplication() {
        if tabBarViewController.parent == nil {
            loadingImageVC.removeFromParentViewController()
            loadingImageVC.view.removeFromSuperview()
            
            tabBarViewController.selectedIndex = 0
            tabBarViewController.customTabBar.selectedIndex = 0
            addChildViewController(tabBarViewController)
            view.addSubview(tabBarViewController.view)
        }
        if needsInitialLoading {
            needsInitialLoading = false
           // core.fire(command: LoadLaunchData())
        }
    }

    fileprivate func showLoadingScreen() {
        tabBarViewController.removeFromParentViewController()
        if let index = view.subviews.index(of: loadingImageVC.view) {
            view.bringSubview(toFront: view.subviews[index])
        } else {
            addChildViewController(loadingImageVC)
            view.addSubview(loadingImageVC.view)
        }
    }
    
}