//
//  CitySearchBar.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CitySearchBar: UISearchBar,UISearchBarDelegate {
    
    var searchBarShouldBeginEditing: (()->())?
    var searchBarDidEndditing: (()->())?
    
    var searchAction: ((_ searchText: String)->Void)?
    var searchTextDidChangedAction: ((_ searchText: String)->Void)?
    var searchBarCancelAction: (()->())?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /** 视图准备 */
        self.viewPrepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /** 视图准备 */
        self.viewPrepare()
    }
    
    /** 视图准备 */
    func viewPrepare(){
        self.backgroundColor = UIColor.clear
        self.backgroundImage = UIImage()
        self.layer.borderColor = CFCityPickerVC.cityPVCTintColor.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = "输出城市名、拼音或者首字母查询"
        self.tintColor = CFCityPickerVC.cityPVCTintColor
        
        self.delegate = self
    }
}

extension CitySearchBar{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarShouldBeginEditing?()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBarDidEndditing?()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarCancelAction?()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAction?(searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTextDidChangedAction?(searchText)
    }
}




