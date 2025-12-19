import '../../ui/app/shared.dart';

class StripeTestPaymentMethods {
  static const String testVisaCard = 'pm_card_visa';
  static const String testMasterCard = 'pm_card_mastercard';
  static const String testAmexCard = 'pm_card_amex';
  static const String testDeclinedCard = 'pm_card_chargeDeclined';
  
  static const Map<String, Map<String, String>> testCards = {
    // ========== SUCCESSFUL PAYMENTS ==========
    'visa_success': {
      'number': '4242424242424242',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Success (Most common test card)'
    },
    'visa_debit_success': {
      'number': '4000056655665556',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa Debit - Success'
    },
    'mastercard_success': {
      'number': '5555555555554444',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'mastercard',
      'description': 'Mastercard - Success'
    },
    'mastercard_debit_success': {
      'number': '5200828282828210',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'mastercard',
      'description': 'Mastercard Debit - Success'
    },
    'amex_success': {
      'number': '378282246310005',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '1234',
      'brand': 'amex',
      'description': 'American Express - Success'
    },
    'amex_success_2': {
      'number': '371449635398431',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '1234',
      'brand': 'amex',
      'description': 'American Express - Success (Alternative)'
    },
    'discover_success': {
      'number': '6011111111111117',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'discover',
      'description': 'Discover - Success'
    },
    'diners_success': {
      'number': '30569309025904',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'diners',
      'description': 'Diners Club - Success'
    },
    'jcb_success': {
      'number': '3566002020360505',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'jcb',
      'description': 'JCB - Success'
    },

    // ========== DECLINED PAYMENTS ==========
    'visa_decline': {
      'number': '4000000000000002',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Generic Decline'
    },
    'visa_insufficient_funds': {
      'number': '4000000000009995',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Insufficient Funds'
    },
    'visa_lost_card': {
      'number': '4000000000009987',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Lost Card'
    },
    'visa_stolen_card': {
      'number': '4000000000009979',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Stolen Card'
    },
    'visa_expired_card': {
      'number': '4000000000000069',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Expired Card'
    },
    'visa_incorrect_cvc': {
      'number': '4000000000000127',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Incorrect CVC'
    },
    'visa_processing_error': {
      'number': '4000000000000119',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Processing Error'
    },

    // ========== 3D SECURE AUTHENTICATION ==========
    'visa_3ds_required': {
      'number': '4000000000003220',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - 3D Secure Required'
    },
    'visa_3ds_optional': {
      'number': '4000000000003063',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - 3D Secure Optional'
    },

    // ========== INTERNATIONAL CARDS ==========
    'visa_brazil': {
      'number': '4000000760000002',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Brazil'
    },
    'visa_canada': {
      'number': '4000001240000000',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Canada'
    },
    'visa_mexico': {
      'number': '4000004840008001',
      'exp_month': '12',
      'exp_year': '2025',
      'cvc': '123',
      'brand': 'visa',
      'description': 'Visa - Mexico'
    }
  };

  static String getTestPaymentMethod() {
    return testVisaCard; 
  }

  static String getDefaultPaymentMethod() {
    return testVisaCard; 
  }

  static Map<String, String>? getTestCardData(String cardType) {
    return testCards[cardType];
  }

  static List<String> getAllTestPaymentMethods() {
    return [
      testVisaCard,
      testMasterCard,
      testAmexCard,
    ];
  }

  // Get all successful test cards
  static List<Map<String, String>> getSuccessfulTestCards() {
    return testCards.entries
        .where((entry) => !entry.key.contains('decline') && 
                         !entry.key.contains('insufficient') && 
                         !entry.key.contains('lost') && 
                         !entry.key.contains('stolen') && 
                         !entry.key.contains('expired') && 
                         !entry.key.contains('incorrect') && 
                         !entry.key.contains('processing') && 
                         !entry.key.contains('3ds'))
        .map((entry) => {
              'type': entry.key,
              ...entry.value,
            })
        .toList();
  }

  // Get test cards that will be declined
  static List<Map<String, String>> getDeclineTestCards() {
    return testCards.entries
        .where((entry) => entry.key.contains('decline') || 
                         entry.key.contains('insufficient') || 
                         entry.key.contains('lost') || 
                         entry.key.contains('stolen') || 
                         entry.key.contains('expired') || 
                         entry.key.contains('incorrect') || 
                         entry.key.contains('processing'))
        .map((entry) => {
              'type': entry.key,
              ...entry.value,
            })
        .toList();
  }

  // Get 3D Secure test cards
  static List<Map<String, String>> get3DSecureTestCards() {
    return testCards.entries
        .where((entry) => entry.key.contains('3ds'))
        .map((entry) => {
              'type': entry.key,
              ...entry.value,
            })
        .toList();
  }

  // Get international test cards
  static List<Map<String, String>> getInternationalTestCards() {
    return testCards.entries
        .where((entry) => entry.key.contains('brazil') || 
                         entry.key.contains('canada') || 
                         entry.key.contains('mexico'))
        .map((entry) => {
              'type': entry.key,
              ...entry.value,
            })
        .toList();
  }

  // Get the default success card for testing
  static Map<String, String> getDefaultSuccessCard() {
    return {
      'type': 'visa_success',
      ...testCards['visa_success']!,
    };
  }

  // Print all available test cards (for debugging)
  static void printAllTestCards() {
    logInfo('\n========== STRIPE TEST CARDS ==========');
    logInfo('🟢 SUCCESSFUL PAYMENTS:');
    for (var card in getSuccessfulTestCards()) {
      logInfo('  • ${card['description']}: ${card['number']}');
    }
    
    logInfo('\n🔴 DECLINED PAYMENTS:');
    for (var card in getDeclineTestCards()) {
      logInfo('  • ${card['description']}: ${card['number']}');
    }
    
    logInfo('\n🔐 3D SECURE CARDS:');
    for (var card in get3DSecureTestCards()) {
      logInfo('  • ${card['description']}: ${card['number']}');
    }
    
    logInfo('\n🌍 INTERNATIONAL CARDS:');
    for (var card in getInternationalTestCards()) {
      logInfo('  • ${card['description']}: ${card['number']}');
    }
    logInfo('=====================================\n');
  }
}