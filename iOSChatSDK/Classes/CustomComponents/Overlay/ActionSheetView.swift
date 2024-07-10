//
//  ActionSheetView.swift
//  SQRCLE
//
//  Created by Dynasas on 10/05/24.
//

import UIKit

class ActionSheetView: UIView {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet private weak var loadView: UIView!
    @IBOutlet weak var constraintSheetHeight: NSLayoutConstraint!
    
    weak var delegate : DelegateActionSheet?
    let actionItemHeight = 48.0
    
    var actions : [ActionSheetItem] = [.discard]{
        didSet{
            setupTable()
            Threads.performTaskInMainQueue {
                self.constraintSheetHeight?.constant = Double(/self.actions.count) * self.actionItemHeight + 24
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view?.tag == 123{
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
        
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("ActionSheetView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
}

extension ActionSheetView : UITableViewDelegate , UITableViewDataSource{
    
    func setupTable(){
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.register([ActionItem.typeName])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActionItem", for: indexPath) as? ActionItem else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.action = actions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actionItemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectItem(action: actions[indexPath.row])
        self.removeFromSuperview()
    }
}
