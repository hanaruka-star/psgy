/// Subdued grey map style — parking markers stay in focus, labels fade back.
abstract final class MapDarkStyle {
  static const json = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#1a2332"}]},
  {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#475569"}, {"visibility": "off"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#1a2332"}, {"weight": 2}]},
  {"featureType": "administrative", "elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "administrative.locality", "stylers": [{"visibility": "off"}]},
  {"featureType": "administrative.neighborhood", "stylers": [{"visibility": "off"}]},
  {"featureType": "poi", "stylers": [{"visibility": "off"}]},
  {"featureType": "transit", "stylers": [{"visibility": "off"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#2d3748"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#374151"}]},
  {"featureType": "road", "elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#374151"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#4b5563"}]},
  {"featureType": "road.highway", "elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "road.arterial", "elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "road.local", "elementType": "labels", "stylers": [{"visibility": "off"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0f172a"}]},
  {"featureType": "water", "elementType": "labels", "stylers": [{"visibility": "off"}]}
]
''';
}
