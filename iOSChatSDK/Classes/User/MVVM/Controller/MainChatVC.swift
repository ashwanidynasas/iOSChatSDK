//
//  MainChatVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 25/06/24.
//

import UIKit

//MARK: - CLASS
public class MainChatVC: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var userChatTV:UITableView!
    
    //MARK: - VIEW MODEL
    private var loginViewModel: ChatViewModel!
    private var viewModel = UserViewModel()
    
    //MARK: - PROPERTIES
    public var tableView: UITableView!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - VIEW CYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Chat SDK"
        CacheManager.shared.shrinkCache(limit: 10 * 1024 * 1024)
        let nib = UINib(nibName: Cell_Chat.custom, bundle: Bundle(for: CustomTableViewCell.self))
        userChatTV.register(nib, forCellReuseIdentifier: Cell_Chat.custom)
        
        
        
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
        //fetch dummy users
        viewModel.fetchUsers()
        
        loginViewModel = ChatViewModel()
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
        
        loginViewModel.login(username: username,
                             loginJWTToken: jwtToken) { accessToken in
            
            if let accessToken = accessToken {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Access Token", message: /accessToken, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.showConnections(userName: username)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
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
        let cell = userChatTV.dequeueReusableCell(withIdentifier: Cell_Chat.custom, for: indexPath) as! CustomTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.senderTextLabel?.text = user.username
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jwt_Token = viewModel.users[indexPath.row].loginJWTtoken
        let userName = viewModel.users[indexPath.row].username
        DispatchQueue.main.async {
            let alert = UIAlertController(title: userName,
                                          message: jwt_Token,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                self.getJWT_Token(jwt_Token,
                                  username: userName)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension MainChatVC{
    func showConnections(userName : String){
        guard let vc = UIStoryboard(name: "MainChat", bundle: Bundle(for: MainChatVC.self)).instantiateViewController(withIdentifier: "ConnectionListVC") as? ConnectionListVC else { return  }
        vc.viewModel = ConnectionViewModel(circleId: "591cd8b1-2288-4e6c-ad7d-c2bdc7d786fe",
                                           circleHash: userName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
