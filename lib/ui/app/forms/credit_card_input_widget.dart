import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardInputWidget extends StatefulWidget {
  final Function(Map<String, String>) onCardDetailsChanged;
  final bool isTestMode;
  final VoidCallback? onValidationChanged;

  const CreditCardInputWidget({
    super.key,
    required this.onCardDetailsChanged,
    this.isTestMode = false,
    this.onValidationChanged,
  });

  @override
  State<CreditCardInputWidget> createState() => _CreditCardInputWidgetState();
}

class _CreditCardInputWidgetState extends State<CreditCardInputWidget> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  final _cardNumberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _nameFocus = FocusNode();

  String _cardBrand = '';
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.isTestMode) {
      _prefillTestCard();
    }
    _setupListeners();
  }

  void _prefillTestCard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardNumberController.text = '4242 4242 4242 4242';
      _expiryController.text = '12/25';
      _cvvController.text = '123';
      _nameController.text = 'Test User';
      _updateCardBrand('4242 4242 4242 4242');
      _validateAndNotify();
    });
  }

  void _setupListeners() {
    _cardNumberController.addListener(() {
      _updateCardBrand(_cardNumberController.text);
      _validateAndNotify();
    });
    _expiryController.addListener(_validateAndNotify);
    _cvvController.addListener(_validateAndNotify);
    _nameController.addListener(_validateAndNotify);
  }

  void _updateCardBrand(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    String brand = '';

    if (cleanNumber.startsWith('4')) {
      brand = 'Visa';
    } else if (cleanNumber.startsWith(RegExp(r'5[1-5]')) ||
        cleanNumber.startsWith(RegExp(r'2[2-7]'))) {
      brand = 'Mastercard';
    } else if (cleanNumber.startsWith(RegExp(r'3[47]'))) {
      brand = 'American Express';
    }

    setState(() {
      _cardBrand = brand;
    });
  }

  void _validateAndNotify() {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text;
    final cvv = _cvvController.text;
    final name = _nameController.text;

    final isCardValid = _validateCardNumber(cardNumber);
    final isExpiryValid = _validateExpiry(expiry);
    final isCvvValid = _validateCVV(cvv);
    final isNameValid = name.trim().isNotEmpty;

    final wasValid = _isValid;
    _isValid = isCardValid && isExpiryValid && isCvvValid && isNameValid;

    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isValid) {
        widget.onCardDetailsChanged({
          'number': cardNumber,
          'expiry_month': expiry.isNotEmpty && expiry.contains('/')
              ? expiry.split('/')[0]
              : '',
          'expiry_year': expiry.isNotEmpty && expiry.contains('/')
              ? '20${expiry.split('/')[1]}'
              : '',
          'cvc': cvv,
          'name': name,
          'brand': _cardBrand.toLowerCase(),
        });
      }

      if (wasValid != _isValid && widget.onValidationChanged != null) {
        widget.onValidationChanged!();
      }
    });
  }

  bool _validateCardNumber(String cardNumber) {
    if (cardNumber.length < 13 || cardNumber.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit = (digit % 10) + 1;
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  bool _validateExpiry(String expiry) {
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) return false;

    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiryDate = DateTime(2000 + year, month + 1);
    return expiryDate.isAfter(now);
  }

  bool _validateCVV(String cvv) {
    if (_cardBrand == 'American Express') {
      return cvv.length == 4 && RegExp(r'^\d{4}$').hasMatch(cvv);
    }
    return cvv.length == 3 && RegExp(r'^\d{3}$').hasMatch(cvv);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _cardNumberFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.15),
            Colors.grey.withOpacity(0.08),
            Colors.grey.withOpacity(0.08),
            Colors.grey.withOpacity(0.12),
          ],
          stops: const [0.0, 0.4, 0.6, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isTestMode)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Test Mode: Using dummy card details',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          TextFormField(
            controller: _cardNumberController,
            focusNode: _cardNumberFocus,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: const Icon(Icons.credit_card),
              suffixIcon: _cardBrand.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _cardBrand,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onFieldSubmitted: (_) => _expiryFocus.requestFocus(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  focusNode: _expiryFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryDateFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'MM/YY',
                    hintText: '12/25',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onFieldSubmitted: (_) => _cvvFocus.requestFocus(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  focusNode: _cvvFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        _cardBrand == 'American Express' ? 4 : 3),
                  ],
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: _cardBrand == 'American Express' ? '1234' : '123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onFieldSubmitted: (_) => _nameFocus.requestFocus(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'John Doe',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;

    if (text.length >= 2) {
      return newValue.copyWith(
        text: '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(
            offset: text.length >= 2 ? text.length + 1 : text.length),
      );
    }

    return newValue;
  }
}
