//
//  CFCityPickerVC+TableView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension CFCityPickerVC: UITableViewDataSource,UITableViewDelegate{
    
    var searchH: CGFloat{return 60}
    
    fileprivate var currentCityModel: CityModel? {if self.currentCity==nil{return nil};return CityModel.findCityModelWithCityName([self.currentCity], cityModels: self.cityModels, isFuzzy: false)?.first}
    fileprivate var hotCityModels: [CityModel]? {if self.hotCities==nil{return nil};return CityModel.findCityModelWithCityName(self.hotCities, cityModels: self.cityModels, isFuzzy: false)}
    fileprivate var historyModels: [CityModel]? {if self.selectedCityArray.count == 0 {return nil};return CityModel.findCityModelWithCityName(self.selectedCityArray, cityModels: self.cityModels, isFuzzy: false)}
    
    fileprivate var headViewWith: CGFloat{return UIScreen.main.bounds.width - 10}
    
    fileprivate var headerViewH: CGFloat{
        
        let h0: CGFloat = searchH
        let h1: CGFloat = 100
        var h2: CGFloat = 100; if self.historyModels?.count > 4{h2+=40}
        var h3: CGFloat = 100; if self.hotCities?.count > 4 {h3+=40}
        return h0+h1+h2+h3
    }
    
    fileprivate var sortedCityModles: [CityModel] {
    
        return cityModels.sorted(by: { (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
        })
    }
    
    
    /** 计算高度 */
    fileprivate func headItemViewH(_ count: Int) -> CGRect{

        let height: CGFloat = count <= 4 ? 96 : 140
        return CGRect(x: 0, y: 0, width: headViewWith, height: height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        //vfl
        let viewDict = ["tableView": tableView]
        let vfl_arr_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        let vfl_arr_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        
        self.view.addConstraints(vfl_arr_H)
        self.view.addConstraints(vfl_arr_V)
    }
    
    
    func notiAction(_ noti: Notification){
        
        let userInfo = noti.userInfo as! [String: CityModel]
        let cityModel = userInfo["citiModel"]!
        citySelected(cityModel)
    }
    
    
    
    
    
    /** 定位处理 */
    func locationPrepare(){
        
        if self.currentCity != nil {return}
        
        //定位开始
        let location = LocationManager.sharedInstance
        
        location.autoUpdate = true

//        location.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
//
//            location.stopUpdatingLocation()
//
//            location.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
//
//                if error != nil {return}
//                if placemark == nil {return}
//                let city: NSString = (placemark!.locality! as NSString).replacingOccurrences(of: "市", with: "") as NSString
//                self.currentCity = city as String
//
//            })
//
//        }
    }
    
    
    
    /** headerView */
    func headerviewPrepare(){
        
        let headerView = UIView()
        
        //搜索框
        searchBar = CitySearchBar()
        headerView.addSubview(searchBar)

        //vfl
        let searchBarViewDict = ["searchBar": searchBar]
        let searchBar_vfl_arr_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-18-[searchBar]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: searchBarViewDict)
        let searchBar_vfl_arr_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[searchBar(==36)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: searchBarViewDict)
        headerView.addConstraints(searchBar_vfl_arr_H)
        headerView.addConstraints(searchBar_vfl_arr_V)
        
        searchBar.searchAction = { (searchText: String) -> Void in
        
            print(searchText)
        
        }
        
        searchBar.searchBarShouldBeginEditing = {[unowned self] in
        
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.searchRVC.cityModels = nil
            
            UIView.animate(withDuration: 0.15, animations: {[unowned self] () -> Void in
                self.searchRVC.view.alpha = 1
            })
        }
        
        
        searchBar.searchBarDidEndditing = {[unowned self] in
            
            if self.searchRVC.cityModels != nil {return}
            
            self.searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.text = ""
        
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animate(withDuration: 0.14, animations: {[unowned self] () -> Void in
                self.searchRVC.view.alpha = 0
            })
        }
        
        searchBar.searchTextDidChangedAction = {[unowned self] (text: String) in
        
            if text.characters.count == 0 {self.searchRVC.cityModels = nil;return}
            
            let searchCityModols = CityModel.searchCityModelsWithCondition(text, cities: self.cityModels)
            
            self.searchRVC.cityModels = searchCityModols
        }
        
        searchBar.searchBarCancelAction = {[unowned self] in
        
            self.searchRVC.cityModels = nil
            self.searchBar.searchBarDidEndditing?()
        }
        
        //SeatchResultVC
        self.searchRVC = CitySearchResultVC(nibName: "CitySearchResultVC", bundle: nil)
        self.addChildViewController(searchRVC)
        
        self.view.addSubview(searchRVC.view)
        self.view.bringSubview(toFront: searchRVC.view)
        searchRVC.view.translatesAutoresizingMaskIntoConstraints = false
        //vfl
        let maskViewDict = ["maskView": searchRVC.view]
        let maskView_vfl_arr_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: maskViewDict)
        let maskView_vfl_arr_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: maskViewDict)
        self.view.addConstraints(maskView_vfl_arr_H)
        self.view.addConstraints(maskView_vfl_arr_V)
        searchRVC.view.alpha = 0
        searchRVC.touchBeganAction = {[unowned self] in
            self.searchBar.endEditing(true)
        }
        
        searchRVC.tableViewScrollAction = { [unowned self] in
            self.searchBar.endEditing(true)
        }
        
        searchRVC.tableViewDidSelectedRowAction = {[unowned self] (cityModel: CityModel) in
            
            self.citySelected(cityModel)
        }
        
        
        headerView.frame = CGRect(x: 0, y: 0, width: headViewWith, height: headerViewH)
        
        let itemView = HeaderItemView.getHeaderItemView("当前城市")
        currentCityItemView = itemView
        var currentCities: [CityModel] = []
        if self.currentCityModel != nil {currentCities.append(self.currentCityModel!)}
        itemView.cityModles = currentCities
        var frame1 = headItemViewH(itemView.cityModles.count)
        frame1.origin.y = searchH
        itemView.frame = frame1
        headerView.addSubview(itemView)
        
        
        
        let itemView2 = HeaderItemView.getHeaderItemView("历史选择")
        var historyCityModels: [CityModel] = []
        if self.historyModels != nil {historyCityModels += self.historyModels!}
        itemView2.cityModles = historyCityModels
        var frame2 = headItemViewH(itemView2.cityModles.count)
        frame2.origin.y = frame1.maxY
        itemView2.frame = frame2
        headerView.addSubview(itemView2)
        
        
        
        let itemView3 = HeaderItemView.getHeaderItemView("热门城市")
        var hotCityModels: [CityModel] = []
        if self.hotCityModels != nil {hotCityModels += self.hotCityModels!}
        itemView3.cityModles = hotCityModels
        var frame3 = headItemViewH(itemView3.cityModles.count)
        frame3.origin.y = frame2.maxY
        itemView3.frame = frame3
        headerView.addSubview(itemView3)
        
        
        self.tableView?.tableHeaderView = headerView
    }
    
    
    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(_ currentCityName: String){
        
        if self.currentCityModel == nil {return}
        if currentCityItemView?.cityModles.count != 0 {return}
        currentCityItemView?.cityModles = [self.currentCityModel!]
    }

    
    /** 处理label */
    func labelPrepare(){
        
        indexTitleLabel.backgroundColor = CFCityPickerVC.rgba(0, g: 0, b: 0, a: 0.4)
        indexTitleLabel.center = self.view.center
        indexTitleLabel.bounds = CGRect(x: 0, y: 0, width: 120, height: 100)
        indexTitleLabel.font = UIFont.boldSystemFont(ofSize: 80)
        indexTitleLabel.textAlignment = NSTextAlignment.center
        indexTitleLabel.textColor = UIColor.white
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
    
        return children==nil ? 0 : children!.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CFCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 44
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]! {
        return indexHandle()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

        showIndexTitle(title)
        
        self.showTime = 1
 
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in

            self.showTime = 0.8

        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
      
            if self.showTime == 0.8 {
                
                self.showTime = 0.6
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
         
            if self.showTime == 0.6 {
                
                self.showTime = 0.4
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            

            if self.showTime == 0.4 {
                
                self.showTime = 0.2
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
 
            if self.showTime == 0.2 {
               
                self.dismissIndexTitle()
            }
            
            
        })
        
        return indexTitleIndexArray[index]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func showIndexTitle(_ indexTitle: String){

        self.dismissBtn.isEnabled = false
        self.view.isUserInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.addSubview(indexTitleLabel)

    }
    
    func dismissIndexTitle(){
        self.dismissBtn.isEnabled = true
        self.view.isUserInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(_ cityModel: CityModel){

        if let cityIndex = self.selectedCityArray.index(of: cityModel.name) {
            self.selectedCityArray.remove(at: cityIndex)
            
        }else{
            if self.selectedCityArray.count >= 8 {self.selectedCityArray.removeLast()}
        }
        
        self.selectedCityArray.insert(cityModel.name, at: 0)
        
        UserDefaults.standard.set(self.selectedCityArray, forKey: SelectedCityKey)
        selectedCityModel?(cityModel)
        delegate?.selectedCityModel(self, cityModel: cityModel)
        self.dismiss()
    }
}



extension CFCityPickerVC{

    /** 处理索引 */
    func indexHandle() -> [String] {
        
        var indexArr: [String] = []
        
        for (index,cityModel) in sortedCityModles.enumerated() {
            let indexString = cityModel.getFirstUpperLetter
            
            if indexArr.contains(indexString) {continue}
            
            indexArr.append(indexString)
            
            indexTitleIndexArray.append(index)
        }
        
        return indexArr
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        indexTitleLabel.center = self.view.center
    }
    

}

