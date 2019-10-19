//
//  ItemSelectorVC.swift
//  ItemSelector
//
//  Created by Amzad Khan on 19/10/19.
//  Copyright © 2019 Amzad Khan. All rights reserved.
//
import UIKit

extension Selectable  {
    var subtitle:String? { return nil }
    var avatarURL:String? { return nil }
    var image:UIImage? { return nil }
}

protocol Selectable {
    
    var id:String { get }
    var title:String { get }
    var subtitle:String? { get }
    var avatarURL:String? { get }
    var image:UIImage? { get }
}

//selectionScrollView
class ItemSelectorVC: UIViewController {
    
    let kBatchSize:Int = 20
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet var selectionScrollView: UICollectionView!
    
    var pageNo:Int = 0
    var searchString = ""
    
    var items  = [SearchUser]()
    var selectedItems = [Selectable]()
    
    @objc var selectedIds:[String] {
        let ids = selectedItems.map { return $0.id }
        return ids
    }
    
    lazy var cellRemoveTap:UserCollectionCell.CellTapHandler? = { (cell) in
        guard let indexPath = self.selectionScrollView.indexPath(for: cell) else {return}
        //remove item
        self.reloadAndPositionScroll(selectItem: self.selectedItems[indexPath.row], remove: true)
        if self.selectedItems.count <= 0 {
            //Comunicate deselection to delegate
            self.toggleSelectionScrollView(show: false)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        configureTableView()
        configureUI()
    }
    
    func configureUI() {
        
        self.title = "Multi Selection"
        let rightBtn = self.postButton(title: "Done")
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func reloadData() {
        //self.apiGetContacts(searchString: searchString)
        self.tableView.reloadData()
    }
    
}
// MARK : - TableviewDatasource
extension ItemSelectorVC : UITableViewDataSource {
    
    @objc fileprivate func postButton(title:String) -> UIBarButtonItem {
        
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 50, height: 22)
        infoButton.setTitle(title, for: .normal)
        infoButton.tintColor = UIColor.orange
        infoButton.setTitleColor(UIColor.orange, for: .normal)
        infoButton.addTarget(self, action: #selector(self.didTapPost), for: .touchUpInside)
        let btn = UIBarButtonItem(customView: infoButton)
        btn.tintColor = UIColor.orange
        
        return  btn
    }
    
    @objc fileprivate func didTapPost() {
        //self.forwardMessage()
    }
    
    func configureTableView() {
        
        self.tableView.tableFooterView = UIView()
        searchBar.placeholder = "Search items..."
        toggleSelectionScrollView(show: false)
        
        // self.apiGetContacts(searchString: searchString)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let returnValue =  self.items.count
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        var item:SearchUser! = self.items[indexPath.row]
        self.configureCell(cell: cell, user:item )
        
        if self.selectedItems.contains(where: { (itm) -> Bool in
            itm.id == item.id
        }) {
            //item.color = cell.initials.backgroundColor!
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    func configureCell(cell:UserSearchCell, user:SearchUser) {
        
        cell.nameLabel.text = user.name
        cell.avatarView.image = user.image
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.section == 0 ? 65 : 65//UITableViewAutomaticDimension
    }
}
// MARK : - TableviewDelegate
extension ItemSelectorVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        let cell = tableView.cellForRow(at: indexPath) as! UserSearchCell
        var item:Selectable = self.items[indexPath.row]
        
        
        //Multi user selection
        //Save item data
        //item.color = cell.initials.backgroundColor!
        //Check if cell is already selected or not
        if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
            //Set accessory type
            cell.accessoryType = UITableViewCell.AccessoryType.none
            //Comunicate deselection to delegate
            //SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item)
            //Reload collectionview
            self.reloadAndPositionScroll(selectItem: item, remove:true)
        }
        else{
            //Set accessory type
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            //Add current item to selected
            selectedItems.append(item)
            //Comunicate selection to delegate
            //SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItem: item)
            //Reload collectionview
            self.reloadAndPositionScroll(selectItem: item, remove:false)
        }
        //Reset search
        if searchString != ""{
            searchBar.text = ""
            searchString = ""
            //SwiftMultiSelect.delegate?.userDidSearch(searchString: "")
            self.tableView.reloadData()
        }
        
        //[self shareSendSwift:message.content];
    }
    /*
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
     
     
     if indexPath.section == 0 {
     
     }else if indexPath.section == 1 {
     if selectedTab == .contacts {
     searchUsers[indexPath.row].isSelected = false
     }else {
     searchGroups[indexPath.row].isSelected = false
     }
     }
     }*/
}

extension ItemSelectorVC: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
        pageNo = 0
        // Get items from for search keyword
        //self.apiGetContacts(searchString: searchText)
        if (searchText.isEmpty) {
            self.perform(#selector(self.hideKeyboardWithSearchBar(_:)), with: searchBar, afterDelay: 0)
            self.searchString = ""
        }
        //API Search
        self.tableView.reloadData()
    }
    
    @objc func hideKeyboardWithSearchBar(_ searchBar:UISearchBar){
        searchBar.resignFirstResponder()
    }
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool{
        return true
    }
}


extension ItemSelectorVC {
    
    @objc class func instantiate() ->ItemSelectorVC {
        let storyboard = UIStoryboard(name:"ItemSelection", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "ItemSelectorVC") as! ItemSelectorVC
    }
    
    @objc public func show(to: UIViewController) {
        // Create instance of selector
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        //Create navigation controller
        let navController       = UINavigationController(rootViewController: self)
        // Present selectora
        to.present(navController, animated: true, completion: nil)
    }
    
    @objc public class func show(to: UIViewController) -> ItemSelectorVC {
        // Create instance of selector
        let vc  = ItemSelectorVC.instantiate()
        vc.show(to: to)
        return vc
    }
}


extension ItemSelectorVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionCell", for: indexPath as IndexPath) as! UserCollectionCell
        
        //Try to get item from delegate
        let item = self.selectedItems[indexPath.row]
        
        //Add target for the button
        
        cell.nameLabel.text        = item.title
        cell.avatarView.isHidden   = false
        cell.didTapRemove          = self.cellRemoveTap
        
        cell.avatarView.image = item.image
        
        //cell.delegate = self
        //Test if items it's CNContact
        return cell
        
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(80),height: CGFloat(80))
    }
    
    /// Remove item from collectionview and reset tag for button
    ///
    /// - Parameter index: id to remove
    func removeItemAndReload(index:Int){
        
        //if no selection reload all
        if selectedItems.count == 0{
            self.selectionScrollView.reloadData()
        }else{
            //reload current
            self.selectionScrollView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    /// Reaload collectionview data and scroll to last position
    ///
    /// - Parameters:
    ///   - idp: is the tableview position index
    ///   - remove: true if you have to remove item
    func reloadAndPositionScroll(selectItem:Selectable, remove:Bool){
        
        //Identify the item inside selected array
        let item = selectedItems.filter { (itm) -> Bool in
            itm.id == selectItem.id
            }.first
        
        //Remove
        if remove {
            //For remove from collection view and create IndexPath, i need the index posistion in the array
            let id = selectedItems.index { (itm) -> Bool in
                return itm.id == selectItem.id
            }
            
            //Filter array removing the item
            selectedItems = selectedItems.filter({ (itm) -> Bool in
                return selectItem.id != itm.id
            })
            
            //Reload collectionview
            if id != nil{
                removeItemAndReload(index: id!)
            }
            
            //SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item!)
            //Reload cell state
            reloadCellState(selectItem:selectItem , selected: false)
            
            if selectedItems.count <= 0{
                //Toggle scrollview
                toggleSelectionScrollView(show: false)
            }
            //Add
        }else{
            toggleSelectionScrollView(show: true)
            //Reload data
            self.selectionScrollView.insertItems(at: [IndexPath(item: selectedItems.count-1, section: 0)])
            let lastItemIndex = IndexPath(item: self.selectedItems.count-1, section: 0)
            
            //Scroll to selected item
            self.selectionScrollView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
            reloadCellState(selectItem: self.selectedItems.last!, selected: true)
        }
    }
}

extension ItemSelectorVC  {
    
    /// Toggle de selection view
    ///
    /// - Parameter show: true show scroller, false hide the scroller
    func toggleSelectionScrollView(show:Bool) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selectionScrollView.isHidden = !show
        })
    }
    
    
    func reloadCellState(selectItem:Selectable, selected:Bool) {
        //get item index from datasource
        guard let indexpaths = self.tableView.indexPathsForVisibleRows else { return }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: indexpaths, with: UITableView.RowAnimation.none)
        self.tableView.endUpdates()
    }
}
