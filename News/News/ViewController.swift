//
//  ViewController.swift
//  News
//
//  Created by Egor Tereshonok on 11/25/19.
//  Copyright © 2019 Egor Tereshonok. All rights reserved.
//

import UIKit
import ExpandableLabel



class NewsViewController: UITableViewController, ExpandableLabelDelegate {

    let numberOfCells : NSInteger = 12
    var states : Array<Bool>!
    private var news = [Articles]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: LOAD AND PARSE JSON
    
    func fetchData() {
        
        let jsonUrlString = "https://newsapi.org/v2/everything?q=apple&from=2019-11-17&to=2019-11-17&sortBy=popularity&apiKey=e51ebcd2cc674fce8bd3c67c2d390675"
        
        guard let url = URL(string: jsonUrlString) else { print("hui"); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let data = try JSONDecoder().decode(News.self, from: data)
                self.news = data.articles!
                self.states = [Bool](repeating: true, count: self.news.count)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
    
    //MARK: Configure cells
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let currentSource = preparedSources()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsTableViewCell
        cell.expandableLabel.delegate = self

        let article = news[indexPath.row]
        //Title
        cell.newsTitle.text = article.title ?? ""
        cell.newsTitle.numberOfLines = 0
        //Image
        cell.newsImage.image = UIImage(named: "noImg")
        if let _ = article.urlToImage {
            DispatchQueue.global().async {
                guard let imageUrl = URL(string: article.urlToImage!) else { return } //FIXIT!!!
                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
                
                DispatchQueue.main.async {
                    cell.newsImage.image = UIImage(data: imageData)
                }
            }
        }

        
       
        cell.newsImage.image = UIImage(named: "noImg")
        
        cell.expandableLabel.setLessLinkWith(lessLink: "Close", attributes: [.foregroundColor:UIColor.red], position: nil)
        
        cell.layoutIfNeeded()
        
        cell.expandableLabel.shouldCollapse = true
        cell.expandableLabel.numberOfLines = 3
        cell.expandableLabel.collapsed = true
        cell.expandableLabel.text = article.description ?? ""
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    //
    // MARK: ExpandableLabel Delegate
    //
    
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
}

extension String {
    
    func specialPriceAttributedStringWith(_ color: UIColor) -> NSMutableAttributedString {
        let attributes = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int),
                          .foregroundColor: color, .font: fontForPrice()]
        return NSMutableAttributedString(attributedString: NSAttributedString(string: self, attributes: attributes))
    }
    
    func priceAttributedStringWith(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color, .font: fontForPrice()]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func priceAttributedString(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    fileprivate func fontForPrice() -> UIFont {
        return UIFont(name: "Helvetica-Neue", size: 13) ?? UIFont()
    }
}




