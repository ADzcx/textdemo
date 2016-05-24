//
//  AnimatedAnnotationView.m
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#import "UIButton+EMWebCache.h"
#import "Manager.h"

#define kWidth          60.f
#define kHeight         60.f
#define kTimeInterval   0.2f

@interface AnimatedAnnotationView ()

@property (nonatomic, strong, readwrite) ThisOne *thisOne;

@end

@implementation AnimatedAnnotationView

@synthesize imageView = _imageView;

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
    
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    
    if ([self.imageView isAnimating])
    {
        [self.imageView stopAnimating];
    }
    
    self.imageView.animationImages      = animatedAnnotation.animatedImages;
    self.imageView.animationDuration    = kTimeInterval * [animatedAnnotation.animatedImages count];
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
}

#pragma mark - Override

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.thisOne pointInside:[self convertPoint:point toView:self.thisOne] withEvent:event];
    }
    
    return inside;
}

-(void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
//        CGRect rect11 = self.frame;
//        rect11 = CGRectMake(0, 0, 220, 360);
//        self.frame = rect11;
//        CGRect rect12 = self.imageView.frame;
//        rect12 = CGRectMake(80, 150, 60, 60);
//        self.imageView.frame = rect12;
        
        if (self.thisOne == nil)
        {
            self.thisOne = [[NSBundle mainBundle] loadNibNamed:@"ThisOneView" owner:self options:nil][0];
            
            self.thisOne.frame = CGRectMake(0, 0, 220, 150);
            
            self.thisOne.layer.cornerRadius = 15;
            
            self.thisOne.clipsToBounds = YES;
            
            self.thisOne.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.thisOne.bounds) / 2.f + self.calloutOffset.y);
        }
        
//        self.calloutView.image = [UIImage imageNamed:@"building"];
//        self.calloutView.title = self.annotation.title;
//        self.calloutView.subtitle = self.annotation.subtitle;
        
        NSUserDefaults *usdf = [NSUserDefaults standardUserDefaults];
        if ([usdf objectForKey:@"jingxiCount"]) {
            NSString *jingxiNB = [usdf objectForKey:@"jingxiCount"];
            //            NSString *jingxiNB = usdic[@"jingxiCount"];
            //            [JingXiCount setTitle:jingxiNB forState:UIControlStateNormal];
            NSLog(@"%@",jingxiNB);
            [self.thisOne.jingxiCountBtn setTitle:jingxiNB forState:UIControlStateNormal];
//            如果没有次数了就不能点了
            if (jingxiNB.intValue < 1) {
                [self.thisOne.jingxiCountBtn setTitle:@"0" forState:UIControlStateNormal];
            self.thisOne.JXBtn.userInteractionEnabled = NO;
            }
        }else
        {
            [self.thisOne.jingxiCountBtn setTitle:@"0" forState:UIControlStateNormal];
            self.thisOne.JXBtn.userInteractionEnabled = NO;
        }
        
        AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
        
        self.thisOne.userName.text = animatedAnnotation.userId;
        
        self.thisOne.userId = animatedAnnotation.mainUserId;
        
        //[self.thisOne.headImage sd_setBackgroundImageWithURL:[NSURL URLWithString:animatedAnnotation.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_logo"]];
        //[self.thisOne.headImage sd_setBackgroundImageWithURL:[NSURL URLWithString:animatedAnnotation.headImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_logo"]];
        
        if(animatedAnnotation.currentImageType)
        {
            [self.thisOne.headImage sd_setBackgroundImageWithURL:[NSURL URLWithString:animatedAnnotation.headImage] forState:UIControlStateNormal];
            self.thisOne.headImageUrl = animatedAnnotation.headImage;
        }else
        {
            [self.thisOne.headImage setBackgroundImage:[UIImage imageNamed:@"icon_logo.png"] forState:UIControlStateNormal];
            self.thisOne.headImageUrl = @"aa";
        }
        
        
        self.thisOne.longitude = animatedAnnotation.longitude;
        
        self.thisOne.latitude = animatedAnnotation.latitude;
        
        if([animatedAnnotation.shield isEqualToString:@"0"])
        {
            
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"0dengjidun.png"] forState:UIControlStateNormal];
            
        }else if ([animatedAnnotation.shield isEqualToString:@"1"])
        {
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"1dengjidun.png"] forState:UIControlStateNormal];
            
        }else if ([animatedAnnotation.shield isEqualToString:@"2"])
        {
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"2dengjidun.png"] forState:UIControlStateNormal];
            
        }else if ([animatedAnnotation.shield isEqualToString:@"3"])
        {
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"3dengjidun.png"] forState:UIControlStateNormal];
            
        }else if ([animatedAnnotation.shield isEqualToString:@"4"])
        {
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"4dengjidun.png"] forState:UIControlStateNormal];
        }else if ([animatedAnnotation.shield isEqualToString:@"5"])
        {
            [self.thisOne.andunImage setImage:[UIImage imageNamed:@"5dengjidun.png"] forState:UIControlStateNormal];
        }
        
        if(![animatedAnnotation.userLocation isEqualToString:@"null"])
        {
            
            self.thisOne.userLocation.text = [NSString stringWithFormat:@"位置:%@",animatedAnnotation.userLocation];
        }
        self.thisOne.userInteractionEnabled = YES;
        
        //self.thisOne.frame = CGRectMake(0, 0, 220, 150);
        
        //self.backgroundColor = [UIColor yellowColor];
        
        Manager *manager = [Manager manager];
        
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(manager.mainView.localCoordinate.latitude ,manager.mainView.localCoordinate.longitude));
        
        MAMapPoint point2;
        
        if(animatedAnnotation.latitude && animatedAnnotation.longitude)
        {
            point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([animatedAnnotation.latitude doubleValue],[animatedAnnotation.longitude doubleValue]));
        }else
        {
            point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(manager.mainView.localCoordinate.latitude, manager.mainView.localCoordinate.longitude));
            
        }
        
        
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        if(distance < 1000)
        {
    
            NSString *disTcStr = [NSString stringWithFormat:@"距离: %.1f米",distance];
            NSString *timeStr = [NSString stringWithFormat:@"步程: %.1f分钟",distance/50];
            self.thisOne.userDistance.text = disTcStr;
            self.thisOne.driveRange.text = timeStr;
//        
//            if ([self hourFromMinute:distance / 1000]>=0.1) {
//                self.thisOne.driveRange.text = [NSString stringWithFormat:@"步程: %.1f分钟",[self hourFromMinute:(distance / 1000) /( 5 * 60)]];
//            }else
//            {
//                 self.thisOne.driveRange.text = [NSString stringWithFormat:@"步程: 0分钟"];
//            }
//
        }else
        {
            self.thisOne.userDistance.text = [NSString stringWithFormat:@"距离: %.1f公里",distance/1000];
            
            self.thisOne.driveRange.text = [NSString stringWithFormat:@"车程: %.1f小时",[self hourFromMinute:(distance/1000/40)]];
            
        }
        
        DbgLog(@"hahahhahah   %f",distance);
        
        NSUserDefaults *usdef = [NSUserDefaults standardUserDefaults];
        NSDictionary *userdic = [usdef objectForKey:@"info"];
        
        if (animatedAnnotation.mainUserId) {
            
            [self addSubview:self.thisOne];
            
        }
        
        DbgLog(@"sbsbsbbsbsbs------>>>>>%@   %@   %@",self,NSStringFromCGRect(self.thisOne.frame),NSStringFromCGPoint(self.calloutOffset));
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 220, 210)];
//        view.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
//        [view addGestureRecognizer:tap];
//        [self addSubview:view];
        
    }
    else
    {
//        CGRect rect12 = self.imageView.frame;
//        rect12 = CGRectMake(0, 0, 60, 60);
//        self.imageView.frame = rect12;
//        CGRect rect11 = self.frame;
//        rect11 = CGRectMake(0, 0, 60, 60);
//        self.frame = rect11;
        
        [self.thisOne removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (double)hourFromMinute:(double)minute
{
    
    if(minute > 60)
    {
        NSInteger hour = minute / 60;
        
        NSInteger hour1 = (int)minute % 60;
        
        NSString *hourStr = [NSString stringWithFormat:@"%d.%d",hour,hour1];
        
        return [hourStr doubleValue];
        
    }else
    {
        return minute;
    }
    
    
}

//- (void)onTapClick:(UITapGestureRecognizer *)sender
//{
//    self.selected = NO;
//}

@end
