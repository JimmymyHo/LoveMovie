//
//  Constants.h
//  LoveMovie
//
//  Created by Ho Jimmy on 13/10/17.
//  Copyright (c) 2013年 Dmitry Kondratyev. All rights reserved.
//

#ifndef LoveMovie_Constants_h
#define LoveMovie_Constants_h

#define ACCESS_KEY_ID                @"AKIAJUSNMJE3HODWBJGA"
#define SECRET_KEY                   @"NSclK+H+epPjrpeDEj1zOPcECLP4GnVqPwnhdOJ1"
#define CREDENTIALS_ALERT_MESSAGE    @"Please update the Constants.h file with your credentials or Token Vending Machine URL."


#define SideViewBackgroundColor 0xFFFFFF
#define SideViewCellColor 0xFFFAFA
#define SideViewStatusColor 0xFFFFFF
#define navColor 0xFFFAFA
#define navTextColor 0x000000

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif


@interface Constants:NSObject {
}

+(UIAlertView *)credentialsAlert;

@end
