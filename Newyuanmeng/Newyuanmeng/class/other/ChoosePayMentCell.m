//
//  ChoosePayMentCell.m
//  huabi
//
//  Created by hy on 2018/1/2.
//  Copyright © 2018年 ltl. All rights reserved.
//

#import "ChoosePayMentCell.h"

@implementation ChoosePayMentCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.isSelect setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e68b", 30, [UIColor colorWithHexString:@"e84f37"])] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(ChoosePayMentCell *)creatCell:(UITableView *)table
{
    static NSString *identify = @"ChoosePayMentCell";
    ChoosePayMentCell *cell = [table dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ChoosePayMentCell" owner:self options:nil][0];
    }
    return cell;
}



@end
