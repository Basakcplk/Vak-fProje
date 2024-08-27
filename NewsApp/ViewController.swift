//
//  ViewController.swift
//  NewsApp
//
//  Created by Apple on 26.08.2024.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    private let tableView: UITableView = {         //bu table haberlerin listeleneceği yer olacak
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var articles = [Article] ()                   // haber makalelerini depolamak için kullanıldı
    private var viewModels = [NewsTableViewCellViewModel] ()
    //Haberler için görüntü modeli verilerini depolamak için bir dizi oluşturur
    
    
    override func viewDidLoad() {       //tablo görünümü yapılandırılır ve haberler API'den çekilir
        super.viewDidLoad()
        title = "Haberler"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        fetchTopStories()        //En üstteki haberleri almak için çağrılan yöntem
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds 
    }
    
    private func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title ?? "nil",
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
            
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Tablolar
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
