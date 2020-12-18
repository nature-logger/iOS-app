//
//  PlantsViewControllers.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//


import UIKit

class PlantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var APIToken = "sqvdZFYkPO5aF0BmIMYoJAkU5hCNM7-uzXdhTmc3row"
    var fetchingMore = false
    var plants = [Plants.Result]()
    var page = 1
    var searchString = ""
    
    /// - Description:This function initalize after the view have loaded
    /// Then it will download the json from the plants API url and pass the data into the table
    /// The table will then reload then reload and show the new data
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.download() {
            
            self.tableView.reloadData()
        }
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    /// - Description:This function sets the search value and reset the page to 1
    ///
    /// - Parameter value: the search string value
    ///
    func setSearch(value: String){
        self.searchString = value;
        self.page = 1
    }
    
    /// - Description:This function returns the number 2, because we have the data for the json and the loadingCell
    ///
    /// - Returns int: Returns the amount of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// - Description:This function returns the number of rows in the each section. If the section is 1 then it will show the loadingCell
    ///
    /// - Returns Int: returns integer for the amount of rows. If there is no rows return 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return plants.count
        }else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
    
    /// - Description: Function for our CustomTableViewCell.
    ///
    /// - Returns UITableViewCell: Returns our custom cell or loading cell if the section is not 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
            let common_name = plants[indexPath.row].common_name
            cell.plantTitle.text = common_name == nil ? "Unkown name" : plants[indexPath.row].common_name.capitalized
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    /// - Description: Function for setting the hight of our section programmatically
    ///
    /// - Returns CGFloat: Returns the hight of the section
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /// - Description: Function to run when the user presses down on a row
    /// When a user presses a row, it would open a segue to the PlantsDetailedView
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    /// - Description: Function to prepare for the new view, passing data to the new view.
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlantsDetailedViewController {
            destination.plant = plants[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    /// - Description: Listens to the scrolling event in the table
    /// If the scrolling hits the bottom it will assume that it has to load more data for the table
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
        
    }
    
    /// - Description: This method runs after 1 second, and ensures that there is a small delay when you hit the bottom of the table
    /// Doing this will prevent the user from overloading the API if the user keeps scroll really fast.
    ///
    func beginBatchFetch() {
        fetchingMore = true;
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.download() {
                self.fetchingMore = false
                self.tableView.reloadData()
            }
        })
    }
    
    /// - Description: This method comes from a question on stackoverflow
    /// When a user enters text it will ensure that there is a delay before starting to fetch the data
    /// Doing this ensures that fast typing users wont overload the API
    ///
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.onSearchDone(_:)), object: searchBar)
        perform(#selector(self.onSearchDone(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    /// - Description: When the user is done searching, this method will run
    ///
    @objc func onSearchDone(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            self.setSearch(value: "")
            self.beginBatchFetch()
            return
        }
        self.setSearch(value: query)
        self.beginBatchFetch()
    }
    
    /// - Description: This function recives deta and pass it in the plants array
    ///
    /// - Parameter data: data from URLSession
    /// - Parameter completed: Function that runs once success
    func getJsonData(data: Data, completed: @escaping () -> ()){
        do {
            
            let jsonData = try JSONDecoder().decode(Plants.self, from: data)
            
            if(self.page == 1){
                self.plants = jsonData.data
            }else{
                self.plants.append(contentsOf: jsonData.data)
            }
            self.page = self.page + 1
            DispatchQueue.main.async {
                completed()
            }
                
        }catch{
            alertResponse();
            print("JSON Error")
        }
    }
    
    /// - Description: This function converts strings into a valid url for our API using URLComponents
    /// Orginal API URL: https://trefle.io/api/v1/plants/?token=sqvdZFYkPO5aF0BmIMYoJAkU5hCNM7-uzXdhTmc3row&page=1
    ///
    /// - Parameter token: The token needed for the API
    /// - Parameter page: The current page for the results
    /// - Parameter serach: Search string to serach in the API
    /// - Returns URL: Return a url to be used by URLSession
    func getApiUrl(token: String, page: Int, search: String) -> URL? {
        var components = URLComponents();
        components.scheme = "https"
        components.host = "trefle.io"
        components.path = "/api/v1/plants/"
        let queryItemToken = URLQueryItem(name: "token", value: token) // sqvdZFYkPO5aF0BmIMYoJAkU5hCNM7-uzXdhTmc3row
        let queryItemPage = URLQueryItem(name: "page", value: String(page))

        components.queryItems = [queryItemToken, queryItemPage]
        
        if(search.isEmpty == false){
            components.path.append("search")
            let queryItemSearchQuery = URLQueryItem(name: "q", value: search)
            components.queryItems?.append(queryItemSearchQuery)
        }
        
        return URL(string: components.url!.absoluteString)
            
    }
    
    /// - Description: This function fetchtes the data from the API URL.
    /// If there is no error in retriving the data, the getJsonData will then run taking the completed paramter with it.
    ///
    /// - Parameter completed: Function that is run when the URLSession is completed
    func download(completed: @escaping () -> ()){

        let url = getApiUrl(token: self.APIToken, page: self.page, search: self.searchString)
        URLSession.shared.dataTask(with: url!){ (data,response, error) in
            if error == nil {
                self.getJsonData(data: data!, completed: completed)
            }else{
                self.alertResponse()
            }
            
        }.resume()
        
    }
    
    /// - Description: Alert response if something went wrong fetching the data.
    ///
    func alertResponse() {
        // create the alert
        let alert = UIAlertController(title: "Json error", message: "Something went wrong.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

