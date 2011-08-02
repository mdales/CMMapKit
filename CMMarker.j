@import <Foundation/CPObject.j>
@import "CMMapView.j"


@implementation CMMarker: CPObject
{
    CMLatLng _location      @accessors(property=location);
    CMIcon   _icon          @accessors(property=icon);
    BOOL     _clickable     @accessors(property=clickable);
    BOOL     _draggable     @accessors(property=draggable);
    CPString _title         @accessors(property=title);
    
    id       _delegate      @accessors(property=delegate);
    
    id      _userInfo       @accessors(property=userInfo);
    
    JSObject _cmObject;
}

///////////////////////////////////////////////////////////////////////////////
//
- (void)setIcon: (CMIcon)icon
{
    _icon = icon;
    
    if (_cmObject)
        _cmObject = nil;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setDraggable: (BOOL)draggable
{
    _draggable = draggable;
    
    if (_cmObject)
    {
        if (draggable)
            _cmObject.enableDragging();
        else
            _cmObject.disableDragging();
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithLatLng: (CMLatLng)location
{
    if (self = [super init])
    {
        _location = location;
        _clickable = YES;
        _draggable = NO;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)clickHandler 
{
    if (_delegate && [_delegate respondsToSelector: @selector(mapMarkerWasClicked:)]) {
        [_delegate mapMarkerWasClicked: self];
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)updateLocation
{
    var cmloc = _cmObject.getLatLng();
    _location = [[CMLatLng alloc] initWithLatitude: cmloc.lat()
        andLongitude: cmloc.lng()];
    
    if (_delegate && [_delegate respondsToSelector:@selector(mapMarker:didMoveToLocation:)]) {
        [_delegate mapMarker:self didMoveToLocation: _location];
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (JSOjbect)cmRepresentation
{
    if (_cmObject)
        return _cmObject;
    
    var cm = [CMMapView2 cmNamespace];
    
    var options = {
        clickable: _clickable,
        draggable: _draggable};
    
    if (_icon)
    {
        icon = [_icon cmRepresentation];
        options.icon = icon;
    }
    
    if (_title)
        options.title = _title;

    var marker = new cm.Marker([_location cmRepresentation], options);    
    
    
    cm.Event.addListener(marker, 'click', function(latlng)
        {
            [self clickHandler];
        }
    );      
    cm.Event.addListener(marker, 'dragend', function()
        {
            [self updateLocation];
        }
    );
        
    _cmObject = marker;
    return marker;
}

@end