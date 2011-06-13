@import <Foundation/CPObject.j>
@import "CMMapView.j"


@implementation CMPolyline: CPObject
{
    CPString _color    @accessors(property=color);
    int      _weight   @accessors(property=weight);
    
    CPArray _pointArray;
    JSObject _cmObject;
}

- (id)init
{
    if (self = [super init])
    {
        _pointArray = [CPArray array];
        _weight = 5;
        _color = [CPColor colorWithHexString: @"#0033ff"];        
    }
    
    return self;
}



- (void)addLatLng: (CMLatLng)location
{
    [_pointArray addObject: location];
}

- (JSObject)cmRepresentation
{
    if (_cmObject)
        return _cmObject;
    
    var cm = [CMMapView cmNamespace];
   
    var list = [];
    for (var i = 0; i < [_pointArray count]; i++)
    {
        var location = [_pointArray objectAtIndex: i];        
        list.push([location cmRepresentation]);
    }
   
    _cmObject = new cm.Polyline(list, [_color hexString], _weight);
    return _cmObject;
}


@end