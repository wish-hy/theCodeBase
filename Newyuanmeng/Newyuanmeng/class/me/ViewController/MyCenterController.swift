//
//
//
//
//
//
////    func selectCenterButton(_ tag: NSInteger) {
////        if tag == 101 {
////            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HBViewController") as! HBViewController
////            login.isFirst = false
////            login.hidesBottomBarWhenPushed = true
////            self.navigationController?.pushViewController(login, animated: true)
////        }else if tag == 102 {
////            //积分明细
////            let info = InteDetailController()
////            info.user_id = CommonConfig.UserInfoCache.userId
////            info.token = CommonConfig.Token
////            info.hidesBottomBarWhenPushed = true
////            self.navigationController?.pushViewController(info, animated: true)
////        }else if tag == 103 {
////            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HBViewController") as! HBViewController
////            login.isFirst = false
////            login.hidesBottomBarWhenPushed = true
////            self.navigationController?.pushViewController(login, animated: true)
////        }else if tag == 104{
////            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HBViewController") as! HBViewController
////            login.isFirst = false
////            login.hidesBottomBarWhenPushed = true
////            self.navigationController?.pushViewController(login, animated: true)
////
////        }else{
////            if !CommonConfig.isLogin {
////                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                self.navigationController?.pushViewController(login, animated: true)
////            }else{
////                if tag == 1001 {
////                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
////                    login.status = "unpay"
////                    self.navigationController?.pushViewController(login, animated: true)
////                }else if tag == 1002 {
////                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
////                    login.status = "unreceived"
////                    self.navigationController?.pushViewController(login, animated: true)
////                }else if tag == 1003 {
////                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
////                    login.status = "comment"
////                    self.navigationController?.pushViewController(login, animated: true)
////                }else if tag == 1004 {
////                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
////                    login.status = "fix"
////                    self.navigationController?.pushViewController(login, animated: true)
////                }else if tag == 1005{
////                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
////                    login.status = "all"
////                    self.navigationController?.pushViewController(login, animated: true)
////                }
////            }
////        }
////    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterViewCell") as! CenterViewCell
//        cell.backgroundColor = UIColor.white
//        if indexPath.row == 0 {
//            cell.setInfo(IconFontIconName.icon_user_setting.rawValue, text: "个人设置", iconColor: UIColor.init(hexCode: "3cd0cb"))
//        }else if indexPath.row == 1 {
//            cell.setInfo(IconFontIconName.icon_msg.rawValue, text: "我的消息", iconColor: UIColor.init(hexCode: "ffa200"))
//        }else if indexPath.row == 2 {
//            cell.setInfo(IconFontIconName.icon_my_address.rawValue, text: "我的地址", iconColor: UIColor.init(hexCode: "9ed03c"))
//        }else if indexPath.row == 3 {
//            cell.setInfo(IconFontIconName.icon_my_collection.rawValue, text: "我的收藏", iconColor: UIColor.init(hexCode: "3cd077"))
//        }else if indexPath.row == 4
////        {
////            cell.setInfo(IconFontIconName.icon_coin_normal.rawValue, text: "我的佣金", iconColor: UIColor.init(hexCode: "3cd827"))
////        }else if indexPath.row == 5
//        {
//            cell.setInfo(IconFontIconName.icon_points_record.rawValue, text: "我的专区", iconColor: UIColor.init(hexCode: "7cd527"))
//        }else if indexPath.row == 5 {
//            cell.setInfo(IconFontIconName.icon_my_order.rawValue, text: "我的推广", iconColor: UIColor.init(hexCode: "4cd127"))
//        }else if indexPath.row == 6 {
//            cell.setInfo(IconFontIconName.icon_customer_service_center.rawValue, text: "客服中心", iconColor: UIColor.init(hexCode: "4dd0e2"))
//        }else if indexPath.row == 7{
//            cell.setInfo(IconFontIconName.icon_about_us.rawValue, text: "关于我们", iconColor: UIColor.init(hexCode: "ce90db"))
//        }
//        cell.selectionStyle = .none
//        return cell
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        if indexRow != nil{
////            let cell = tableView.cellForRow(at: indexRow!) as! CenterViewCell
////            cell.backgroundColor = UIColor.white
////            indexRow = nil
////        }
////        tableView.deselectRow(at: indexPath, animated: false)
////        if indexPath.row == 0 {
////            toLogin()
////        }else if indexPath.row == 1 {
////            if CommonConfig.isLogin  {
////                let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
////                info.isShow = false
////                info.isSystem = false
////                info.isFirst = false
////                info.isCollect = false
////                self.navigationController?.pushViewController(info, animated: true)
////            }else{
////                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                login.isGoods = true
////                self.navigationController?.pushViewController(login, animated: true)
////            }
////        }else if indexPath.row == 2 {
////            if CommonConfig.isLogin  {
////
////                self.performSegue(withIdentifier: "address", sender: self)
////            }else{
////                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                login.isGoods = true
////                self.navigationController?.pushViewController(login, animated: true)
////            }
//
////        }else if indexPath.row == 3 {
////            if CommonConfig.isLogin  {
////                let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
////                info.isShow = false
////                info.isSystem = false
////                info.isCollect = true
////                info.isFirst = false
////                self.navigationController?.pushViewController(info, animated: true)
////             }else{
////                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                login.isGoods = true
////                self.navigationController?.pushViewController(login, animated: true)
////            }
//
////        }else if indexPath.row == 4
////            {//我的佣金
////
////            if CommonConfig.isLogin {
////                //请求
////                RequestManager.RequestData(RequestUrl.Router.judgeCommission(userid: CommonConfig.UserInfoCache.userId, token: CommonConfig.Token), successCallBack: { (result) in
////                    print(result)
////
////                    if result["message"].string == "成功" {
////
////                        let commissionVC = MyCommissionController()
////                        self.hidesBottomBarWhenPushed = true;
////                        commissionVC.user_id = CommonConfig.UserInfoCache.userId;
////                        commissionVC.token = CommonConfig.Token;
////                        self.navigationController?.pushViewController(commissionVC, animated: true)
////                        self.hidesBottomBarWhenPushed = false;
////                    }
////
////                    }, failCallBack: { (falseStr) in
//////                        print(falseStr)
////                        self.noticeOnlyText(falseStr)
////                })
////
////            }else{
////                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                login.isGoods = true
////                self.navigationController?.pushViewController(login, animated: true)
////            }
////
////
////        }else if indexPath.row == 5
//        {//我的专区
//
//
//
//
//        }else if indexPath.row == 6 {
//            if CommonConfig.isLogin {
//                self.performSegue(withIdentifier: "mess", sender: self)
//            }else{
//                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                login.isGoods = true
//                self.navigationController?.pushViewController(login, animated: true)
//            }
//
//        }else if indexPath.row == 7{
//            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutUsController") as! AboutUsController
//            self.navigationController?.pushViewController(login, animated: true)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//
//        let cell = tableView.cellForRow(at: indexPath) as! CenterViewCell
//        cell.backgroundColor = UIColor.init(hexCode: "efefef")
//        indexRow = indexPath
//    }
//    
//    var indexRow:IndexPath?
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//
//        if indexRow != nil{
//            let cell = tableView.cellForRow(at: indexRow!) as! CenterViewCell
//            cell.backgroundColor = UIColor.white
//            indexRow = nil
//        }
//    }
//
//    @IBAction func gologin(_ sender: UIButton) {
//        toLogin()
//    }
//
//    func toLogin(){
//        if CommonConfig.isLogin {
////            print("denglen");
//            let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
//            info.img = avatar.image!
//            self.navigationController?.pushViewController(info, animated: true)
//        }else{
//
//            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            self.navigationController?.pushViewController(login, animated: true)
////            print("未登录");
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setInfo()
//         UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.setNeedsStatusBarAppearanceUpdate()
//    }
//
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
//
//    override var prefersStatusBarHidden : Bool {
//        return false
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func refreshFive(){
////        print("refresh5")
//        setInfo()
//
//    }
//    //let notice = NSNotification.init(name: "badgeRefresh", object: ["badge":"1","tag":"101"])
////    NSNotificationCenter.defaultCenter().postNotification(notice)
//    func badgeRefresh(_ notification:Notification){
//        let info = notification.object as! NSDictionary
//        let text = info.value(forKey: "badge") as! String
//        let tag = info.value(forKey: "tag") as! String
//        for btn in btnArr {
//            if btn.tag == Int(tag) {
//                btn.setbadge(text)
//            }
//        }
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
