//
//  FavoriteVC.swift
//  NewsApp
//
//  Created by finebel on 25.08.20.
//

import UIKit

//Custom subclass of UITableViewDiffableDataSource in order to allow editing.
class FavoritedArticlesDataSource: UITableViewDiffableDataSource<HomeFeedVC.Section, Article> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let article = itemIdentifier(for: indexPath) {
                var snapshot = self.snapshot()
                snapshot.deleteItems([article])
                apply(snapshot)
                
                PersistenceManager.shared.removeFavoriteArticle(article: article) {
                    NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
                }
            }
        }
    }
}

class FavoriteVC: HomeFeedVC {

    private let emptyStateView = EmptyStateView(imageSystemName: "star", text: "Es sind keine Favoriten verfügbar")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.refreshControl = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(getArticles), name: .favoritesDidChange, object: nil)
    }
    
    //Reset the editing mode of tableView after user leave FavoriteVC
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setEditing(false, animated: false)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    override func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favoriten"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func getArticles() {
        self.articles = PersistenceManager.shared.getAllFavoriteArticles()
        updateData(articles: articles)
        
        if articles.isEmpty {
            tableView.backgroundView = emptyStateView
            navigationItem.rightBarButtonItem = nil
            tableView.isScrollEnabled = false
        } else {
            tableView.backgroundView = nil
            navigationItem.rightBarButtonItem = editButtonItem
            tableView.isScrollEnabled = true
        }
    }
    
    override func configureDataSource() {
        dataSource = FavoritedArticlesDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, article) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as? NewsTableViewCell
            cell?.setCell(article: article)
            
            return cell
        })
    }
}
