//
//  MTSubHomeTableCell.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/2.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTSubHomeTableCell.h"

@implementation MTSubHomeTableCell

+ (instancetype)subTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"subCell";
    MTSubHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MTSubHomeTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
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
