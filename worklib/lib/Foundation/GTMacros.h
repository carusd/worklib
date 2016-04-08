//
//  GTMacros.h
//  iGuitar
//
//  Created by carusd on 14-6-4.
//  Copyright (c) 2014年 GuitarGG. All rights reserved.
//

#ifndef iGuitar_GTMacros_h
#define iGuitar_GTMacros_h

// 设备相关
#define GTIs4Inch() ([[UIScreen mainScreen] bounds].size.height == 568)
#define GTValue(v35, v4) (GTIs4Inch() ? (v4) : (v35))

#define GTWeak(obj) {__weak typeof(obj) wObj = obj}

// 视图相关
#define GTViewSetOrigin(view, point) { \
CGRect frame = view.frame; \
frame.origin.x = point.x; \
frame.origin.y = point.y; \
view.frame = frame; \
}

#define GTResetViewOrigin(view) { \
CGRect frame = view.frame; \
frame.origin.x = 0; \
frame.origin.y = 0; \
view.frame = frame; }

#define GTMoveViewToLeft(view, offset) { \
CGRect frame = view.frame; \
frame.origin.x -= offset; \
view.frame = frame; \
}

#define GTMoveViewToRight(view, offset) { \
CGRect frame = view.frame; \
frame.origin.x += offset; \
view.frame = frame;}

#define GTMoveViewToUpside(view, offset) { \
CGRect frame = view.frame; \
frame.origin.y -= offset; \
view.frame = frame; \
}

#define GTMoveViewToDownside(view, offset) { \
CGRect frame = view.frame; \
frame.origin.y += offset; \
view.frame = frame; \
}

#define GTView_X(a) (a.frame.origin.x)
#define GTView_Y(a) (a.frame.origin.y)
#define GTView_H(a) (a.frame.size.height)
#define GTView_W(a) (a.frame.size.width)

// 颜色相关
#define GTColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define GTMainColor (GTColor(236, 127, 7, 1))

// 默认图
#define GTDefaultImage() ([UIImage imageNamed:@""])
#endif
