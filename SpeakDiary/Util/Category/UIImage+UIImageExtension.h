//
//  UIImage+UIImageExtension.h
//  neo_gooddoc_ios
//
//  Created by yellomobile on 2015. 2. 16..
//  Copyright (c) 2015년 Yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExtension)
+ (UIImage *)imageNamed:(NSString *)name forSession:(id)session;
+ (void)clearSession:(id)session;
@end


/*
 UIImage의 imageNamed의 특징은 단순히 이름으로 파일을 열어서 이미지를 불러오지만 캐싱한다는 점이 있습니다.
 이 캐싱은 장단점이 있습니다.
 먼저 문제는 한번 로드하면 해제를 안합니다.
 
 imageNamed는 한번 로드후 계속 사용하지만
 imageWithContentsOfFile은 그때그때 바로 로드 하기 때문이죠
 
 

 예를 들면
 
 간단한 네이게이션 구조의 화면 앱을 만든다 할때
 
 뷰 컨트롤러A에서만 사용하는 이미지들,
 뷰 컨트롤러B에서만 사용하는 이미지들,
 뷰 컨트롤러C에서만 사용하는 이미지들,
 
 이런식으로 각각의 뷰컨에서 전용으로 사용하는 이미지가 있을겁니다.
 
 imageNamed는 같이 쓰기 때문에 세군데에서 전부 이미지를 로드 하게 됩니다
 
 한 뷰컨트롤러만 보고있을때 다른 이미지는 필요없는데 계속 가지고 있는 낭비가 됩니다.
 
 
 그리고 다른 문제는 이미 어느정도 개발을 한 상태라면 뷰컨A,B,C에서 이미 다 imageNamed를 사용 하고 있을것이란거죠
 
 이제와서 imageNamed를 다른방식으로 다 바꾸기에는 늦었고
 그렇다고 해서 각각의 뷰컨에다 NSMutableDictionary를 일일이 만들어 넣는것도 일입니다.
 
 
 
 결국 조건은 최소한의 수정으로 원하는 기능을 구현해야 한다는 겁니다.
 
 
 
 ******
 메모리 낭비를 해결하기 위하여 각 뷰컨에 대한 세션을 분별하여 이미 로딩되어 캐시에 저장되어 있는 이미지를 다시 불리는 현상이 발생하지 않도록 하기 위한 Category
 ******
*/