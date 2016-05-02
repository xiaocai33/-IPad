//
//  MTMainHomeTableCell.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTMainHomeTableCell.h"

@implementation MTMainHomeTableCell

#pragma mark - 初始化
+ (instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"mainCell";
    MTMainHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MTMainHomeTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = selectedBg;
    }
    
    return self;
}


@end
