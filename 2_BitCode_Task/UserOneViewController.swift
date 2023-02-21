//
//  ViewController.swift
//  2_BitCode_Task
//
//  Created by Admin on 18/02/23.
//

import UIKit
import SDWebImage

class UserOneViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var userCollectionView: UICollectionView!
    var usersAll:[User1] = [User1]()
    var userSearching:[User1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        fetchData()
        setSearchBar()
    }
    
    private func setSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Search by user name"
    }
    
    private func setCollectionView(){
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        let nib = UINib(nibName: "UserCollectionViewCell", bundle: nil)
        userCollectionView.register(nib, forCellWithReuseIdentifier: "UserCollectionViewCell")
    }
    
    func fetchData(){
        let url = URL(string: "https://dummyjson.com/users")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){
            data,response,error in
            if error == nil{
                let jsonObject = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
                let allUsers = jsonObject["users"] as! [[String:Any]]
                for i in allUsers{
                    let firstName = i["firstName"] as! String
                    let lastName = i["lastName"] as! String
                    let imageUrl = i["image"] as! String
                    let name:String = firstName + " " + lastName
                    let userObject = User1(fullName: name, imageUrl: imageUrl)
                    self.usersAll.append(userObject)
                    self.userSearching.append(userObject)
                }
                
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
            }
            else{
                print("Please Check Internet")
            }
        }.resume()
    }
}

extension UserOneViewController:UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("CollectionView Did Select \(indexPath.row)")
//        let userImageUrl =  URL(string: usersAll[indexPath.row].imageUrl)
//        let userImageView = UIImageView(frame: CGRectMake(10, 10, 250, 124))
//        userImageView.sd_setImage(with: userImageUrl!)
//        let userName:String = usersAll[indexPath.row].firstName + " " + usersAll[indexPath.row].lastName
//        let imagePopup = UIAlertController(title: userName, message: nil, preferredStyle: .alert)
//        imagePopup.view.addSubview(userImageView)
//        present(imagePopup, animated: true)
//    }
}

extension UserOneViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userSearching.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        let user = userSearching[indexPath.row]
        cell.userName.text = user.fullName
        let url = URL(string: user.imageUrl)
        cell.userImage.sd_setImage(with: url)
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
        cell.layer.borderWidth = 2
        return cell
    }

}

extension UserOneViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2 - 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}


extension UserOneViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text else{return}
            if searchText == ""{
                userSearching = usersAll
            }
            else{
                userSearching = usersAll
                userSearching = usersAll.filter({
                    return $0.fullName.contains(searchText)
                })
            
            }
            userCollectionView.reloadData()
    }
}
