//
//  MainChatVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 25/06/24.
//

import UIKit
//import MatrixSDK

public class MainChatVC: UIViewController {

    @IBOutlet weak var userChatTV:UITableView!
    
    let tableCell = "CustomTableViewCell"
    private var viewModel = UserViewModel()
    public var tableView: UITableView!
    var jwt_Token:String!
    var access_token:String!
    
    private var loginViewModel: LoginViewModel!

    // Required initializer for Storyboard support
       public required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Chat SDK"
        
        //Custom Cell register.
        let nib = UINib(nibName: tableCell, bundle: Bundle(for: CustomTableViewCell.self))
        userChatTV.register(nib, forCellReuseIdentifier: "customTableViewCell")
        
        viewModel.usersDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.userChatTV.reloadData()
            }
        }
        viewModel.errorDidChange = { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    self?.showError(errorMessage)
                }
            }
        }
        viewModel.fetchUsers()
        
        loginViewModel = LoginViewModel()
    }
    
    public func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    public static func instantiate() -> MainChatVC {
        let bundle = Bundle(for: MainChatVC.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MainChatVC") as? MainChatVC else {
            fatalError("SDK not found in CustomPods")
        }
        return viewController
    }
    public func getJWT_Token(_ jwtToken:String, username:String){
        loginViewModel.login(username: username, loginJWTToken: jwtToken) { accessToken in
            if let accessToken = accessToken {
                print("Access Token: \(accessToken)")
                self.access_token = accessToken
                
                let alert = UIAlertController(title: "Stored Token", message: self.access_token, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Failed to retrieve access token")
            }
        }
    }
   
}

//MARK: - Table Delegate & Datasource
extension MainChatVC: UITableViewDelegate,UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userChatTV.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as! CustomTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.senderTextLabel?.text = user.username

        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("JWT_Token ---> ")
        print(viewModel.users[indexPath.row].loginJWTtoken)
        jwt_Token = viewModel.users[indexPath.row].loginJWTtoken
        self.getJWT_Token(jwt_Token, username: viewModel.users[indexPath.row].username)
        
        let alert = UIAlertController(title: viewModel.users[indexPath.row].username, message: jwt_Token, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
