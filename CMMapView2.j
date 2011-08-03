@import <AppKit/CPView.j>
@import "CMLatLng.j"
@import "CMMarker.j"
@import "CMIcon.j"
@import "CMPolyline.j"
@import "CMLatLngBounds.j"

var cmNamespace = nil;



@implementation CMMapView2: CPView
{
    id          _delegate       @accessors(property=delegate);
    
    CPString    _apiKey;
    
    JSObject    _map;
    JSObject    _scaleControl;
    JSObject    _largeMapControl;
}


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithFrame: (CGRect)aFrame
    apiKey: (CPString)apiKey
{
    if (self = [super initWithFrame: aFrame])
    {    
        _apiKey = apiKey;
        hasLoaded = NO;
        
        _largeMapControl = nil;
        _scaleControl = nil;
        
        var bounds = [self bounds];
        
        var _div = document.createElement("div");
        _div.style.width = "100%";
        _div.style.height = "100%";
        _div.style.background = "#ffffff";
        _div.id = "CMMapViewDiv";
        
        self._DOMElement.appendChild(_div);    
        
        setTimeout(function() { [self finishLoadMap];}, 0);
            
    }
    
    return self    
}

///////////////////////////////////////////////////////////////////////////////
//
- (void)finishLoadMap
{
    
    var cloudmade = new CM.Tiles.CloudMade.Web({key: _apiKey, styleId: 28647});  
    _map = new CM.Map('CMMapViewDiv', cloudmade);
        
    _map.setCenter(new CM.LatLng(51.514, -0.137), 5);
	    
	if (_delegate && [_delegate respondsToSelector:@selector(mapViewIsReady:)]) 
	{
        [_delegate mapViewIsReady:self];
    }
}



///////////////////////////////////////////////////////////////////////////////
//
+ (JSObject)cmNamespace 
{
    console.log(CM);
    return CM;
}


///////////////////////////////////////////////////////////////////////////////
//
- (CMLatLng)center
{
    var cmCenter = _map.getCenter();
    
    return [[CMLatLng alloc] initWithLatitude: cmCenter.lat()
        andLongitude: cmCenter.lng()];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setCenter: (CMLatLng)location
{
    _map.setCenter([location cmRepresentation]);
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setCenter: (CMLatLng)location andZoom: (int)zoom
{
    _map.setCenter([location cmRepresentation], zoom);
}


///////////////////////////////////////////////////////////////////////////////
//
- (CPInteger)zoom
{
    return _map.getZoom();
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setZoom: (CPInteger)zoom
{
    _map.setZoom(zoom);
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)zoomToBounds: (CMLatLngBounds)bounds
{
    _map.zoomToBounds([bounds cmRepresentation]);
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)addOverlay: (id)overlay
{    
    _map.addOverlay([overlay cmRepresentation]);
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)removeOverlay: (id)overlay
{
    _map.removeOverlay([overlay cmRepresentation]);
}


///////////////////////////////////////////////////////////////////////////////
//
- (JSObject)cmRepresentation
{
    return _map;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)showScaleControl: (BOOL)shouldShow
{
    var cm = [CMMapView2 cmNamespace];	
    
    if (shouldShow)
    {
        if (_scaleControl == nil)
        {
            _scaleControl = new cm.ScaleControl()
            _map.addControl(_scaleControl);
        }
    }
    else
    {
        if (_scaleControl != nil)
        {
            _map.removeControl(_scaleControl);
            _scaleControl = nil;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)showLargeMapControl: (BOOL)shouldShow
{
    var cm = [CMMapView2 cmNamespace];	
    
    if (shouldShow)
    {
        if (_largeMapControl == nil)
        {
	        var topRight = new cm.ControlPosition(cm.TOP_LEFT, new cm.Size(2, 2));
	        _largeMapControl = new cm.LargeMapControl();
            _map.addControl(_largeMapControl, topRight);
        }
    }
    else
    {
        if (_largeMapControl != nil)
        {
            _map.removeControl(_largeMapControl);
            _largeMapControl = nil;
        }
    }
}
				


@end