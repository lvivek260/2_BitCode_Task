//
//  UserTwoViewController.swift
//  2_BitCode_Task
//
//  Created by Admin on 18/02/23.
//

import UIKit
import SDWebImage

class UserTwoViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var usersAll:[User1] = [User1]()
    var searchUsers:[User1] = [User1]()
    var jsonDataArray:[User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        fetchData()
        setSearchBar()
    }
    
    private func setSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Search by user name"
        
    }
    
    private func setTableView(){
        userTableView.delegate = self
        userTableView.dataSource = self
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")
    }
    
    private func fetchData(){
        let url = URL(string: "https://dummyjson.com/users")
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request){
            data,response,error in
            if error == nil{
                let object = try! JSONDecoder().decode(User2Data.self, from: data!)
                self.jsonDataArray = object.users
                for i in self.jsonDataArray{
                    let name:String = i.firstName + " " + i.lastName
                    let imageUrl:String = i.image
                    let newElement = User1(fullName: name, imageUrl: imageUrl)
                    self.usersAll.append(newElement)
                    self.searchUsers.append(newElement)
                }
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
            else{
                print("Please Check Internet")
            }
        }
        dataTask.resume()
    }
}

extension UserTwoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = searchUsers[indexPath.row]
        let url = URL(string: user.imageUrl)
        cell.userImage.sd_setImage(with: url)
        cell.userName.text = user.fullName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension UserTwoViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text else{return}
            if searchText == ""{
                searchUsers = usersAll
            }
            else{
                searchUsers = usersAll.filter({
                    return $0.fullName.contains(searchText)
                })
            
            }
            userTableView.reloadData()
    }
}

