//
//  CitySearchResultVC.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CitySearchResultVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var touchBeganAction: (()->())!
    var tableViewScrollAction: (()->())!
    var tableViewDidSelectedRowAction: ((_ cityModel: CFCityPickerVC.CityModel)->())!
    
    var cityModels: [CFCityPickerVC.CityModel]!{didSet{dataPrepare()}}
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
}

extension CitySearchResultVC{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cityModels == nil {return 0}
        
        return cityModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CFCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = cityModels[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableViewDidSelectedRowAction?(cityModels[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.cityModels == nil {return nil}
        return "共检索到\(self.cityModels.count)到记录"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBeganAction?()
    }
    
    func dataPrepare(){
        
        self.tableView.isHidden = self.cityModels == nil
        
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewScrollAction?()
    }
}




