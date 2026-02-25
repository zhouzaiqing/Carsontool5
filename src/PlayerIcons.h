//
//  PlayerIcons.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/25/23.
//

@interface BuffIcon : UIButton

- (void)InitializeImages;
- (void)move:(float)x y:(float)y;

@end

@interface WeaponIcon : UIButton

- (void)InitializeImages;
- (void)move:(float)x y:(float)y;

@end

@interface PlayerArmorIcon : UIButton

@property (nonatomic, strong) CATextLayer *DuraPercent;
 
- (void)InitializeImages;
- (void)move:(float)x y:(float)y;
- (void)SetDurability:(float)Percentage;

@end

class ArmorIcons {
private:
    PlayerArmorIcon* ArmorButtons[5];
    BuffIcon* BuffButtons[5];
    WeaponIcon* WeaponButton;
    
    
public:
    
    void Reset();
    void Initialize();
    void DrawForPlayer(Vector2 ScreenLocation, UObject* Player);
    
};
