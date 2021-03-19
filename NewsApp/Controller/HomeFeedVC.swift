//
//  HomeFeedVC.swift
//  NewsApp
//
//  Created by finebel on 04.08.20.
//

import UIKit

class HomeFeedVC: UIViewController {
    enum Section {
        case main
    }
    
    let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, Article>?
    
    var articles: [Article] = []
    
    private var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureRefreshControl()
        configureTableView()
        configureDataSource()
        getArticles()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getArticles), for: .valueChanged)//pull to refresh
    }
    
    @objc
    func getArticles() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
        showLoadingSpinner()
        NetworkManager.shared.getArticles { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsResponse):
                self.articles = newsResponse.articles
                self.updateData(articles: self.articles)

            case .failure(let error):
                self.presentWarningAlert(title: "Fehler", message: error.rawValue)
            }
            self.dismissLoadingSpinner()
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Nachrichten"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToEdges(of: view)
        tableView.delegate = self
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Article>(tableView: tableView, cellProvider: { (tableView, indexPath, article) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as? NewsTableViewCell
            cell?.setCell(article: article)
            
            return cell
        })
    }
    
    func updateData(articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles, toSection: .main)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: self.tableView.window != nil)
        }
    }

    func showLoadingSpinner() {
        containerView = UIView()
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: view)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.85
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingSpinner() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }
}

extension HomeFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedArticle = dataSource?.itemIdentifier(for: indexPath) {
            let detailVC = DetailVC(article: selectedArticle, articles: articles)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
