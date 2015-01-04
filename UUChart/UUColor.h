//
//  UUColor.h
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *  System Versioning Preprocessor Macros
 */

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define UUGrey         [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0f]
#define UULightBlue    [UIColor colorWithRed:94.0/255.0 green:147.0/255.0 blue:196.0/255.0 alpha:1.0f]
#define UUGreen        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define UUTitleColor   [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:113.0/255.0 alpha:1.0f]
#define UUButtonGrey   [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0f]
#define UUFreshGreen   [UIColor colorWithRed:77.0/255.0 green:196.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define UURed          [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
#define UUMauve        [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:103.0/255.0 alpha:1.0f]
#define UUBrown        [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f]
#define UUBlue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]
#define UUDarkBlue     [UIColor colorWithRed:121.0/255.0 green:134.0/255.0 blue:142.0/255.0 alpha:1.0f]
#define UUYellow       [UIColor colorWithRed:242.0/255.0 green:197.0/255.0 blue:117.0/255.0 alpha:1.0f]
#define UUWhite        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f]
#define UUDeepGrey     [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
#define UUPinkGrey     [UIColor colorWithRed:200.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0f]
#define UUHealYellow   [UIColor colorWithRed:245.0/255.0 green:242.0/255.0 blue:238.0/255.0 alpha:1.0f]
#define UULightGrey    [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
#define UUCleanGrey    [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0f]
#define UULightYellow  [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]
#define UUDarkYellow   [UIColor colorWithRed:152.0/255.0 green:150.0/255.0 blue:159.0/255.0 alpha:1.0f]
#define UUPinkDark     [UIColor colorWithRed:170.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0f]
#define UUCloudWhite   [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f]
#define UUBlack        [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0f]
#define UUStarYellow   [UIColor colorWithRed:252.0/255.0 green:223.0/255.0 blue:101.0/255.0 alpha:1.0f]
#define UUTwitterColor [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:243.0/255.0 alpha:1.0]
#define UUWeiboColor   [UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]
#define UUiOSGreenColor [UIColor colorWithRed:98.0/255.0 green:247.0/255.0 blue:77.0/255.0 alpha:1.0]
#define UURandomColor   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f]

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min){
    CGRange p;
    p.max = max;
    p.min = min;
    return p;
}

static const CGRange CGRangeZero = {0,0};

@interface UUColor : NSObject
- (UIImage *)imageFromColor:(UIColor *)color;
@end
