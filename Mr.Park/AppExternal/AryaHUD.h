//
//  ESMHUD.h
//  ESafeMove
//
//  Created by vishnu on 12/12/13.
//  Copyright (c) 2013 Aryavrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AryaHUD : UIView{

    UIActivityIndicatorView *aIndicatorView;
    UILabel *lblHUDText;
    BOOL isSuperViewIntractionEnabled;
    
}
@property(nonatomic,assign)BOOL isSuperViewIntractionEnabled;
-(void)hide;
-(void)show;
-(void)resetFrame;
-(void)setHUDText:(NSString*)HUDText;
@end
