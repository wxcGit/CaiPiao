//
//  UIColor+theme.m
//  CaiPiaoApp
//
//  Created by 王学超 on 2017/7/8.
//  Copyright © 2017年 王学超. All rights reserved.
//

#import "UIColor+theme.h"

@implementation UIColor (theme)

+ (UIColor*)backGroundColor
{
    return [UIColor themeBackgroundColor];
}

//tab normal
+ (UIColor*)tabNormalColor
{
    return [UIColor themeBlackColor];
}

//tab select
+ (UIColor*)tabSelectColor
{
    return [UIColor themeRedColor];
}

+(UIColor *)themeRedColor
{
    return HexColor(0xe84c3d);
}

+(UIColor *)themeNaviRedColor
{
    return HexColor(0xef3a3a);
}

+(UIColor *)themeNaviWhiteColor
{
    return HexColor(0xffffff);
}

+(UIColor *)themeNaviBlackColor
{
    return HexColor(0x333333);
}

+(UIColor *)themeBlackColor
{
    return HexColor(0x111111);
}

+(UIColor *)themeMiddleBlackColor
{
    return HexColor(0x666666);
}

+(UIColor *)themeLightBlackColor
{
    return HexColor(0x333333);
}

+(UIColor *)themeLightGray3Color
{
    return HexColor(0x999999);
}

+(UIColor *)themeGrayColor
{
    return HexColor(0xf7f7f7);
}

+(UIColor *)themeLightGrayColor
{
    return HexColor(0xf9f9f9);
}

+(UIColor *)themeLightGray1Color
{
    return HexColor(0xaaaaaa);
}

+(UIColor *)themeLightGray2Color
{
    return HexColor(0xebebeb);
}

+(UIColor *)themeOrangeColor
{
    return HexColor(0xfc461e);
}

+(UIColor *)themeBackgroundColor
{
    return HexColor(0xf0f0f0);
}

+(UIColor *)themeSplitLineColor
{
    return HexColor(0xf3f4f5);
}


@end
