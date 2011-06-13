@import <AppKit/CPView.j>
@import "CMLatLng.j"
@import "CMMarker.j"
@import "CMIcon.j"
@import "CMPolyline.j"
@import "CMLatLngBounds.j"

var cmNamespace = nil;

@implementation CPWebView(ScrollFixes) {
    - (void)loadHTMLStringWithoutMessingUpScrollbars:(CPString)aString
    {
        [self _startedLoading];
    
        _ignoreLoadStart = YES;
        _ignoreLoadEnd = NO;
    
        _url = null;
        _html = aString;
    
        [self _load];
    }
}
@end



@implementation CMMapView: CPWebView
{
    CPString    _apiKey;
    id          _delegate       @accessors(property=delegate);
    BOOL        hasLoaded;
    
    JSObject    _map;
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
        
        var bounds = [self bounds];
        [self setFrameLoadDelegate:self];
        [self loadHTMLStringWithoutMessingUpScrollbars:@"<html><head><script type=\"text/javascript\" src=\"http://tile.cloudmade.com/wml/latest/web-maps-lite.js\"></script></head><body style='padding:0px; margin:0px'><div id='CMMapViewDiv' style='left: 0px; top: 0px; width: 100%; height: 100%'></div></body></html>"];
    }
    
    return self    
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)webView:(CPWebView)aWebView didFinishLoadForFrame:(id)aFrame 
{
    if (hasLoaded)
        return;        
    hasLoaded = YES;    

    [self loadInitialMap];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)loadInitialMap() 
{
    var domWin = [self DOMWindow];

    if (typeof(domWin.CM) === 'undefined') 
    {
        domWin.window.setTimeout(function() {[self loadInitialMap];}, 100);
    } 
    else 
    {
        cmNamespace = domWin.CM;
        var cmScriptElement = domWin.document.createElement('script');
        domWin.mapsJsLoaded = function (map) {
            console.log(map);
            _map = map;
            _DOMMapElement = domWin.document.getElementById('CMMapViewDiv');
            [self finishLoadMap];
        };
        cmScriptElement.innerHTML = "var key = '" + _apiKey + "'; console.log(key); var cloudmade = new CM.Tiles.CloudMade.Web({key: key, styleId: 28647});  var map = new CM.Map('CMMapViewDiv', cloudmade); mapsJsLoaded(map);";
        domWin.document.getElementsByTagName('head')[0].appendChild(cmScriptElement);     
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)finishLoadMap
{
    var cm = [CMMapView cmNamespace];
    
    _map.addControl(new cm.ScaleControl());
	var topRight = new cm.ControlPosition(cm.TOP_RIGHT, new cm.Size(10, 10));
	_map.addControl(new cm.SmallMapControl(), topRight);	

	_map.setCenter(new cm.LatLng(51.514, -0.137), 5);

	if (_delegate && [_delegate respondsToSelector:@selector(mapViewIsReady:)]) 
	{
        [_delegate mapViewIsReady:self];
    }
}


///////////////////////////////////////////////////////////////////////////////
//
+ (JSObject)cmNamespace 
{
    return cmNamespace;
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
- (void)setZoom: (int)zoom
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
				