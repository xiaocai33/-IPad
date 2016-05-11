//
//  MTDealTool.m
//  美团IPad
//
//  Created by 小蔡 on 16/5/10.
//  Copyright © 2016年 xiaocai. All rights reserved.
//

#import "MTDealTool.h"
#import "FMDatabase.h"
#import "MTDeals.h"

@implementation MTDealTool
static FMDatabase *_db;
+ (void)initialize{
    // 1.打开数据库
    NSString *dicPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deals.sqlite"];
    _db = [FMDatabase databaseWithPath:dicPath];
    [_db open];
    
    // 2.创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];

}

/** 收藏一个团购 */
+ (void)addCollectDeal:(MTDeals *)deal{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES (%@, '%@');", data, deal.deal_id];
}
/** 取消收藏一个团购 */
+ (void)removeCollectDeal:(MTDeals *)deal{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = '%@';", deal.deal_id];
}

/** 返回第page页的收藏团购数据:page从1开始 */
+ (NSArray *)collectDeals:(int)page{
    int size = 20;
    int pos = (page - 1) * size;
    
    FMResultSet *set =[_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"deal"];
        MTDeals *deal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [deals addObject:deal];
    }
    
    return deals;
}

/** 团购是否收藏 */
+ (BOOL)isCollected:(MTDeals *)deal{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = '%@';", deal.deal_id];
    [set next];
    return [set intForColumn:@"deal_count"] == 1;
}

/** 收藏团购的数目 */
+ (int)collectDealsCount{
    FMResultSet *set = [_db executeQuery:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}

@end
