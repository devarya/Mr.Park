//
//  ESMHUD.m
//  ESafeMove
//
//  Created by vishnu on 12/12/13.
//  Copyright (c) 2013 Aryavrat. All rights reserved.
//

#define FONT_SIZE 11
#define FONT_NAME @"Arial"

#import "AryaHUD.h"
@implementation AryaHUD
@synthesize isSuperViewIntractionEnabled;
- (id)init
{
    
    aIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    lblHUDText = [[UILabel alloc]init];
    
    self = [super initWithFrame:CGRectMake(0,0, 60, 60)];
    if (self) {
        
        [self addSubview:aIndicatorView];
        [self addSubview:lblHUDText];
        lblHUDText.text = @"";
        lblHUDText.frame = CGRectMake(7, 43, 50, 13);
        lblHUDText.textColor = [UIColor whiteColor];
        lblHUDText.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
        aIndicatorView.frame = self.bounds;
        aIndicatorView.center = self.center;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 9;
        self.layer.opacity = 0.9f;
        self.hidden = YES;
    }
    
    return self;
}

-(void)setHUDText:(NSString*)HUDText{
    
    lblHUDText.text = HUDText;
    UIFont *font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGFloat width = [[[NSAttributedString alloc] initWithString:HUDText attributes:attributes] size].width;
    self.frame = CGRectMake(0, 0, width+15, 60);
    lblHUDText.frame = CGRectMake(7, 43, width, 13);
    
    [self resetFrame];
}

-(void)hide{
    
    [self.superview setUserInteractionEnabled:YES];
    [aIndicatorView stopAnimating];
    self.hidden = YES;
}
-(void)show{
    
    self.center = self.superview.center;
    if (isSuperViewIntractionEnabled) {
        [self.superview setUserInteractionEnabled:YES];
    }else{
        [self.superview setUserInteractionEnabled:NO];
    }
    
    [aIndicatorView startAnimating];
    self.hidden = NO;
}
-(void)resetFrame{
    
    aIndicatorView.center = CGPointMake(self.center.x, self.center.y);
    self.center = self.superview.center;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
