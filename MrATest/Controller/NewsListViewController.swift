//
//  NewsListViewController.swift
//  MrATest
//
//  Created by Kevin Fachal on 16/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var categoryPicker: UIPickerView!
    
    var productArray = [Any]()
    var showAllDataNews : [showData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryField.text = UserDefaults.standard.string(forKey: "category")
        
        findButton.layer.cornerRadius = 8
        
        categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryField.inputView = categoryPicker
        
        getNews()
    }

    @IBAction func findAction(_ sender: Any) {
        productArray.removeAll()
        showAllDataNews.removeAll()
        getNews()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showAllDataNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell : NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        if showAllDataNews[indexPath.row].urlImageValue != "" {
            let url = URL(string: showAllDataNews[indexPath.row].urlImageValue)
            let data = try? Data(contentsOf: url!)

            if let imageData = data {
                let image = UIImage(data: imageData)
                newsCell.newsImage.image = image
            }
        }

        newsCell.newsTitleLabel.text = showAllDataNews[indexPath.row].titleValue
        newsCell.newsDescLabel.text = showAllDataNews[indexPath.row].descValue
        newsCell.newsAuthorLabel.text = showAllDataNews[indexPath.row].authorValue

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let convertedDate = dateFormatter.date(from: showAllDataNews[indexPath.row].dateValue)!
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let resultDate = dateFormatter.string(from: convertedDate)
        print(resultDate)

        newsCell.newsDateLabel.text = resultDate
        
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var stringRows = ""
        if pickerView == categoryPicker {
            stringRows = categoryList[row]
        }
        
        return stringRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == categoryPicker {
            categoryField.text! = categoryList[row]
            UserDefaults.standard.set(categoryList[row], forKey: "category")
            self.view.endEditing(true)
        }
    }
    
    func getNews() {
        showAllDataNews = []
        AF.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=da5b3fc7f0c94bf8a872b8e90195df8f&category=" + UserDefaults.standard.string(forKey: "category")! , method: .get ,encoding: JSONEncoding.default).responseString {
        response in switch response.result {
        case .success(let data):
            print(data)
            
            if let data = response.data {
            guard let json = try? JSON(data: data) else { return }
            self.productArray = json.arrayValue
            print(json)
            for (_, subJson) in json["articles"] {
                
                let titleData = subJson["title"].string ?? ""
            
                let authorData = subJson["author"].string ?? ""
                let dateData = subJson["publishedAt"].string ?? ""
                let descData = subJson["description"].string ?? ""
                let urlData = subJson["url"].string ?? ""
                let urlImageData = subJson["urlToImage"].string ?? ""
                
                self.showAllDataNews.append(showData(titleValue: titleData, authorValue: authorData, dateValue: dateData, descValue: descData, urlValue: urlData, urlImageValue: urlImageData))
                }
            }
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
            }
        }
    }
    
}
