//
//  DetailVC.swift
//  NewsApp
//
//  Created by finebel on 13.08.20.
//

import UIKit
import SafariServices

class DetailVC: UIViewController {
    
    private let titleLabel = NewsLabel(fontStyle: .headline)
    private let imageView = NewsImageView(frame: .zero)
    private let infoLabel = NewsLabel(fontStyle: .footnote, textAlignment: .center)
    private let contentLabel = NewsLabel(fontStyle: .body)
    private let readArticleButton = NewsButton(backgroundColor: .systemBlue, title: "Zum ganzen Artikel")
    
    private let stackView = UIStackView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    ///Current article which gets displayed. Each time this attribute is set there is a check whether  `downButton` or / and `upButton` should be en-/disabled (based on the position of `article` in  `articles`.
    private var article: Article! {
        didSet {
            guard let articles = articles, let currentIndex = articles.firstIndex(of: article) else {
                upButton.isEnabled = false
                downButton.isEnabled = false
                return
            }
            
            if currentIndex == 0 {
                upButton.isEnabled = false
            } else {
                upButton.isEnabled = true
            }
            
            if currentIndex == articles.count - 1 {
                downButton.isEnabled = false
            } else {
                downButton.isEnabled = true
            }
        }
    }
    private var articles: [Article]?
    
    lazy var upButton = UIBarButtonItem(image: .systemArrowUp, style: .plain, target: self, action: #selector(handleUpButtonDidTap))
    
    lazy var downButton = UIBarButtonItem(image: .systemArrowDown, style: .plain, target: self, action: #selector(handleDownButtonDidTap))
    
    lazy var favoriteButton = UIBarButtonItem(image: .systemEmptyStar, style: .plain, target: self, action: #selector(handleFavoriteButtonDidTap))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailVC()
        configureUI()
        setElements(article: article)
        configureReadArticleButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(respondToChangedFavoriteStatus), name: .favoritesDidChange, object: nil)
    }
    
    init(article: Article, articles: [Article]) {
        super.init(nibName: nil, bundle: nil)
        
        //The closure is used so that didSet of article gets executed
        ({
            self.articles = articles
            self.article = article
        })()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDetailVC() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [downButton, upButton, favoriteButton]
    }
    
    ///This method is responsible for changing the favorite status of the current article after the user has tapped on `favoriteButton`
    @objc
    private func handleFavoriteButtonDidTap() {
        if PersistenceManager.shared.isArticleAlreadyFavorite(article: article) {
            PersistenceManager.shared.removeFavoriteArticle(article: article) {
                NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            }
        } else {
            PersistenceManager.shared.addFavoriteArticle(article: article) {
                NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            }
        }
    }
    
    //Called after the favorite status of an article has changed. Responsible for updating the favorite UIBarButtonItem (favoriteButton)
    @objc
    private func respondToChangedFavoriteStatus() {
        favoriteButton.image = PersistenceManager.shared.isArticleAlreadyFavorite(article: article) ? .systemFillStar : .systemEmptyStar
    }
    
    @objc
    private func handleDownButtonDidTap() {
        guard let currentIndex = articles?.firstIndex(of: article), let nextArticle = articles?[currentIndex + 1] else { return }
        article = nextArticle
        setElements(article: article)
    }
    
    @objc
    private func handleUpButtonDidTap() {
        guard let currentIndex = articles?.firstIndex(of: article), let nextArticle = articles?[currentIndex - 1] else { return }
        article = nextArticle
        setElements(article: article)
    }
    
    private func configureReadArticleButton() {
        readArticleButton.addTarget(self, action: #selector(handleReadArticleButtonDidTap), for: .touchUpInside)
    }
    
    ///This method is responsible for opening a `SFSafariViewController` and display a website based on the url of `article`
    @objc
    private func handleReadArticleButtonDidTap() {
        guard let url = URL(string: article.url ?? "") else {
            presentWarningAlert(title: "Fehler", message: "Die gewünschte URL konnte nicht geöffnet werden.")
            return
        }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let safariVC = SFSafariViewController(url: url, configuration: config)
        present(safariVC, animated: true)
    }
    
    //Sets up a ScrollView containing a UIStackView which holds all the UIElements defined above.
    private func configureUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view, considerSafeArea: true)
        
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView)
        stackView.pinToEdges(of: contentView, withPadding: 10, considerSafeArea: true)
    }
    
    func setElements(article: Article) {
        stackView.removeAllArrangedSubviews()
        stackView.addArrangedSubviews([titleLabel, imageView, infoLabel, contentLabel, readArticleButton])
        
        self.titleLabel.text = article.title
        self.contentLabel.text = article.content == nil || article.content == "" ? article.description : article.content
        
        self.infoLabel.text = "Autor: \(article.author ?? "N/A") / \(article.publishedAt?.getStringRepresentation() ?? "N/A")"
        
        self.imageView.setImage(urlToImageString: article.urlToImage)
        
        favoriteButton.image = PersistenceManager.shared.isArticleAlreadyFavorite(article: article) ? .systemFillStar : .systemEmptyStar
    }
}
