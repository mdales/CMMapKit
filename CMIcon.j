@import <Foundation/CPObject.j>
@import "CMMapView.j"

@implementation CMIcon: CPObject
{
    CPString _imageURL      @accessors(property=imageURL);
    CPString _shadow        @accessors(property=shadow);
    CGSize   _size          @accessors(property=size);
    CGPoint  _anchorPoint   @accessors(property=anchorPoint);
}


- (id)initWithImageURL: (CPString)imageURL
{
    if (self = [super init])
    {
        _imageURL = imageURL;
    }
    
    return self;
}

- (JSObject)cmRepresentation
{
    var cm = [CMMapView cmNamespace];

	var icon = new cm.Icon();
    icon.image = _imageURL;
    
    icon.shadow = _shadow;
    
    if (_size)
    {
        var cmSize = new cm.Size(_size.width, _size.height);
        icon.iconSize = cmSize;
    }
    
    if (_anchorPoint)
    {
        var cmPoint = new cm.Point(_anchorPoint.x, _anchorPoint.y);
        icon.iconAnchor = cmPoint;
        
    }
    
    return icon;
}


@end