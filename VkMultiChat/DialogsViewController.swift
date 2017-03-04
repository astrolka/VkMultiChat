//
//  ViewController.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 14.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit
import NMessenger
import VK_ios_sdk

class DialogsViewController: UIViewController, NodeProtocol {
    
    var viewModel: DialogsViewModel!
    var tableNode: ASTableNode!
    var shouldLoad = false
    private var refreshControl: UIRefreshControl!
    
    //MARK: - Initializtion
    
    required init(viewModel: Any) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel as! DialogsViewModel
        
        tableNode = ASTableNode(style: .plain)
        tableNode.delegate = self
        tableNode.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(self, action: #selector(refreshTableNode), for: .valueChanged)
        tableNode.view.addSubview(refreshControl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - layout

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Сообщения"
        view.addSubnode(tableNode)
        setNeedsStatusBarAppearanceUpdate()
        insertDialogs()
    }
    
    override func viewWillLayoutSubviews() {
        tableNode.frame = view.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Memory managment

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    
    func insertDialogs() {
        shouldLoad = false
        viewModel.loadDialogs(complition: { (indexPaths) in
            self.tableNode.insertRows(at: indexPaths, with: .fade)
            self.shouldLoad = true
        }) { (error) in
            self.shouldLoad = true
        }
    }
    
    @objc private func refreshTableNode () {
        shouldLoad = false
        viewModel.refreshDialogs(complition: { (updateIndexPaths, deleteIndexPaths) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.tableNode.deleteRows(at: deleteIndexPaths, with: .none)
                self.tableNode.reloadRows(at: updateIndexPaths, with: .fade)
                self.shouldLoad = true
                if updateIndexPaths.count > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.refreshControl.endRefreshing()
                    })
                } else {
                    self.refreshControl.endRefreshing()
                }
                
            })
        }) { (error) in
            self.refreshControl.endRefreshing()
            self.shouldLoad = true
        }
    }


}

extension DialogsViewController: ASTableDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {() -> ASCellNode in
            return self.viewModel.conversations[indexPath.row].getCellNode()
        }
    }
    
}

extension DialogsViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let min = CGSize(width: UIScreen.main.bounds.width, height: 0)
        let max = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        
        return ASSizeRange(min: min, max: max)
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.view.deselectRow(at: indexPath, animated: true)
        if let cell = tableNode.nodeForRow(at: indexPath) as? CellNodeProtocol {
            cell.performSelection()
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.global().async {
            if !self.shouldLoad {
                return
            }
            let contentOffset = scrollView.contentOffset.y
            let contentSize = scrollView.contentSize.height
            let delta: CGFloat = (Util.isIpad() ? 160 : 80) * 20
            if contentSize - contentOffset < delta {
                self.shouldLoad = false
                self.insertDialogs()
            }
        }
    }
}

