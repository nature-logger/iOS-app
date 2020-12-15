//
//  PlantsViewControllers.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//


import UIKit

class PlantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var fetchingMore = false
    var heros = [Plants.Result]()
    var page = 1
    var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        downloadJSON {
            self.tableView.reloadData()
        }
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setSearch(value: String){
        self.searchString = value;
        self.page = 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return heros.count
        }else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
            let common_name = heros[indexPath.row].common_name
            cell.plantTitle.text = common_name == nil ? "Unkown name" : heros[indexPath.row].common_name.capitalized
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlantsDetailedViewController {
            destination.hero = heros[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
        
    }
    
    func beginBatchFetch() {
        fetchingMore = true;
        print("beginBatchFetch")
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.downloadJSON {
                self.fetchingMore = false
                self.tableView.reloadData()
            }
        })
    }
    
    // Needs to fix space search issue

    func downloadJSON(completed: @escaping () -> ()){
        var urlString = "https://trefle.io/api/v1/plants/?token=sqvdZFYkPO5aF0BmIMYoJAkU5hCNM7-uzXdhTmc3row&page=1"
        
        if(searchString.isEmpty == false){
            urlString = "https://trefle.io/api/v1/plants/search?token=sqvdZFYkPO5aF0BmIMYoJAkU5hCNM7-uzXdhTmc3row&page=1&q=\(self.searchString)"
        }
        
        print(urlString)

        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!){ (data,response, error) in
            if error == nil {
                do {
                    let jsonData = try JSONDecoder().decode(Plants.self, from: data!)
                    
                    if(self.page == 1){
                        self.heros = jsonData.data
                    }else{
                        self.heros.append(contentsOf: jsonData.data)
                    }
                    self.page = self.page + 1

                    DispatchQueue.main.async {
                        completed()
                    }
                    
                }catch{
                    print("JSON Error", response)
                }
            }
            
        }.resume()
    }
}

extension PlantsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.setSearch(value: searchText)
        self.beginBatchFetch()
    }
}

