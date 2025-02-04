//
//  ConnectionListVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import UIKit

class ConnectionListVC: UIViewController {
    
    @IBOutlet weak var listTableView:UITableView!
    let tableCell = "CustomTableViewCell"
    private var cListViewModel: ConnectionViewModel!

    var chatUserID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Connection List"

        let nib = UINib(nibName: tableCell, bundle: Bundle(for: CustomTableViewCell.self))
        listTableView.register(nib, forCellReuseIdentifier: "customTableViewCell")
        cListViewModel = ConnectionViewModel()
        cListViewModel.bindViewModelToController = {
            self.updateUI()
        }
        print("chat userID----> \(String(describing: chatUserID))")
        cListViewModel.fetchConnections(circleId: "591cd8b1-2288-4e6c-ad7d-c2bdc7d786fe", circleHash: chatUserID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
       
    
}

//MARK: - Table Delegate & Datasource
extension ConnectionListVC:UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cListViewModel.connections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let connection = cListViewModel.connections[indexPath.row]
        cell.senderTextLabel.isHidden = true
        cell.textLabel?.text = connection.chatUserId

        if !connection.imageInfo.url.isEmpty, let imageUrl = URL(string: connection.imageInfo.url) {
            // Fetch image data asynchronously
            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        // Check if the cell is still visible for the original indexPath
                        guard let currentCell = tableView.cellForRow(at: indexPath) else { return }
                        currentCell.imageView?.image = UIImage(data: imageData)
                        currentCell.setNeedsLayout() // Request layout update
                    }
                } catch {
                    print("Error fetching image data for \(imageUrl): \(error)")
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(named: "placeholder")
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("JWT_Token ---> ")
        let bundle = Bundle(for: ConnectionListVC.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as? ChatRoomVC else {
            fatalError("ViewController Not Found")
        }
        let selectedChatUserId = cListViewModel.connections[indexPath.row].chatUserId
        print("selectedChatUserId   <<<----\(selectedChatUserId)")
        viewController.chatUserID = selectedChatUserId
        viewController.currentUser = "@\(self.chatUserID ?? ""):chat.sqrcle.co"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
