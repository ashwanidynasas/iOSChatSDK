//
//  ConnectionListVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

//MARK: - MODULES
import UIKit

//MARK: - CLASS
class ConnectionListVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var listTableView:UITableView!
    
    //MARK: - PROPERTIES
    var viewModel: ConnectionViewModel?

    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Connection List"

        let nib = UINib(nibName: Cell_Chat.custom, bundle: Bundle(for: CustomTableViewCell.self))
        listTableView.register(nib, forCellReuseIdentifier: Cell_Chat.custom)
        viewModel?.bindViewModelToController = {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK: - UITABLEVIEW DELEGATES
extension ConnectionListVC: UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /viewModel?.connections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: Cell_Chat.custom, for: indexPath) as! CustomTableViewCell
        
        guard let connection = viewModel?.connections[indexPath.row] else { return UITableViewCell() }
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
        
//        guard let vc = UIStoryboard(name: "MainChat", bundle: Bundle(for: ConnectionListVC.self)).instantiateViewController(withIdentifier: "ChatRoomVC") as? ChatRoomVC else { return }
//        let ChatRoom = ChatRoomVC()
//        ChatRoom.viewModel = ChatRoomViewModel(connection: viewModel?.connections[indexPath.row], accessToken: "", curreuntUser: "")
//        self.navigationController?.pushViewController(ChatRoom, animated: true)
    }
    
}



