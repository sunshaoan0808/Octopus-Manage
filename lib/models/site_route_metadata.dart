import 'package:octopusmanage/utils/parse_utils.dart';

class SiteModelRouteMetadata {
  final String kind;
  final int version;
  final String source;
  final bool routeSupported;
  final SiteModelRouteType routeType;
  final List<String> enableGroups;
  final List<String> supportedEndpointTypes;
  final List<String> heuristicEndpointTypes;
  final List<String> normalizedEndpointTypes;
  final String unsupportedReason;

  SiteModelRouteMetadata({
    this.kind = '',
    this.version = 0,
    this.source = '',
    this.routeSupported = false,
    this.routeType = null,
    this.enableGroups = const [],
    this.supportedEndpointTypes = const [],
    this.heuristicEndpointTypes = const [],
    this.normalizedEndpointTypes = const [],
    this.unsupportedReason = '',
  });

  factory SiteModelRouteMetadata.fromJson(Map<String, dynamic> json) {
    return SiteModelRouteMetadata(
      kind: parseString(json['kind']),
      version: parseInt(json['version']),
      source: parseString(json['source']),
      routeSupported: parseBool(json['route_supported']),
      routeType: SiteModelRouteType.fromJson(parseJsonMap(json['route_type'])),
      enableGroups: parseJsonMapList(json['enable_groups']).map(String.fromJson).toList(),
      supportedEndpointTypes: parseJsonMapList(json['supported_endpoint_types']).map(String.fromJson).toList(),
      heuristicEndpointTypes: parseJsonMapList(json['heuristic_endpoint_types']).map(String.fromJson).toList(),
      normalizedEndpointTypes: parseJsonMapList(json['normalized_endpoint_types']).map(String.fromJson).toList(),
      unsupportedReason: parseString(json['unsupported_reason']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (kind.isNotEmpty) 'kind': kind,
      'version': version,
      if (source.isNotEmpty) 'source': source,
      'route_supported': routeSupported,
      'route_type': routeType.toJson(),
      'enable_groups': enableGroups.map((e) => e.toJson()).toList(),
      'supported_endpoint_types': supportedEndpointTypes.map((e) => e.toJson()).toList(),
      'heuristic_endpoint_types': heuristicEndpointTypes.map((e) => e.toJson()).toList(),
      'normalized_endpoint_types': normalizedEndpointTypes.map((e) => e.toJson()).toList(),
      if (unsupportedReason.isNotEmpty) 'unsupported_reason': unsupportedReason,
    };
  }
}

