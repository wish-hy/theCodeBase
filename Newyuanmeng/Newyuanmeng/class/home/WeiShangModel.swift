//
//Created by ESJsonFormatForMac on 17/12/22.
//

import UIKit

class WeiShangModel: NSObject {

    var weishang_data: [Weishang_Data]?

    var page: Page?

}

class Page: NSObject {

    var page: Int = 0

    var pageSize: Int = 0

    var total: String?

    var totalPage: Int = 0

}

class Weishang_Data: NSObject {

    var status: String?

    var img: String?

    var subtitle: String?

    var ID: String?

    var listorder: String?

    var imgs: [String]?

    var sell_price: String?

    var price_set: [Price_Set]?

    var is_adjustable: String?

    var name: String?

    var goods_id: String?

}

class Price_Set: NSObject {

    var point: String?

    var cash: String?

}

