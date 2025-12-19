class AIEventValidator {
  const AIEventValidator();

  bool isValidEvent(Map<String, dynamic> eventData) {
    if (eventData['name'] == null || 
        eventData['name'].toString().trim().isEmpty) {
      return false;
    }

    if (eventData['currency'] != null && 
        eventData['currency'].toString().trim().isEmpty) {
      return false;
    }

    if (eventData['location'] != null && eventData['location'] is Map) {
      final location = eventData['location'] as Map;
      final lat = location['latitude'];
      final lng = location['longitude'];
      
      if ((lat == null || lng == null) || 
          (lat is num && lng is num && (lat == 0.0 && lng == 0.0))) {
        return false;
      }
    }

    if (eventData['start'] == null) {
      return false;
    }

    return true;
  }


}
