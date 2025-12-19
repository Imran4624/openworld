import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeConnectScreen extends StatefulWidget {
  const StripeConnectScreen({Key? key}) : super(key: key);

  static const String route = '/stripe_connect';

  @override
  _StripeConnectScreenState createState() => _StripeConnectScreenState();
}

class _StripeConnectScreenState extends State<StripeConnectScreen> {
  final StripeService _stripeService = StripeService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessUrlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _bankAccountNumberController =
      TextEditingController();
  final TextEditingController _bankRoutingNumberController =
      TextEditingController();
  final TextEditingController _bankAccountHolderController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _connectAccount;
  String _businessType = 'individual';
  String _country = 'US';

  @override
  void initState() {
    super.initState();
    _loadConnectAccount();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _businessUrlController.dispose();
    _phoneController.dispose();
    _bankAccountNumberController.dispose();
    _bankRoutingNumberController.dispose();
    _bankAccountHolderController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  Future<void> _loadConnectAccount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
     
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load connect account: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createConnectAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _stripeService.createStripeConnectAccount(
        email: _emailController.text.trim(),
        businessType: _businessType,
        country: _country,
        firstName: _businessType == 'individual'
            ? _firstNameController.text.trim()
            : null,
        lastName: _businessType == 'individual'
            ? _lastNameController.text.trim()
            : null,
        businessName: _businessType == 'company'
            ? _businessNameController.text.trim()
            : null,
        businessUrl: _businessUrlController.text.isNotEmpty
            ? _businessUrlController.text.trim()
            : null,
        phone: _phoneController.text.isNotEmpty
            ? _phoneController.text.trim()
            : null,
        refreshUrl: 'https://yourapp.com/connect/refresh',
        returnUrl: 'https://yourapp.com/connect/return',
        bankAccountNumber: _bankAccountNumberController.text.isNotEmpty
            ? _bankAccountNumberController.text.trim()
            : null,
        bankRoutingNumber: _bankRoutingNumberController.text.isNotEmpty
            ? _bankRoutingNumberController.text.trim()
            : null,
        bankAccountHolderName: _bankAccountHolderController.text.isNotEmpty
            ? _bankAccountHolderController.text.trim()
            : (_businessType == 'individual'
                ? '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                    .trim()
                : _businessNameController.text.trim()),
        bankName: _bankNameController.text.isNotEmpty
            ? _bankNameController.text.trim()
            : null,
      );

      if (result['success'] == true) {
        final accountData = result['data'] as Map<String, dynamic>?;
        setState(() {
          _connectAccount = accountData;
        });
        _showSuccessDialog(
            'Stripe Connect account created successfully! Please complete the onboarding process.');
      } else {
        final errorMessage =
            result['error']?.toString() ?? 'Failed to create connect account';
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating connect account: ${e.toString()}';
      });
      logError('Error creating connect account: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        setState(() {
          _errorMessage = 'Could not launch onboarding URL';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error launching URL: ${e.toString()}';
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              Text('Business Type',
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Individual'),
                      value: 'individual',
                      groupValue: _businessType,
                      onChanged: (value) {
                        setState(() {
                          _businessType = value!;
                        });
                      },
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Company'),
                      value: 'company',
                      groupValue: _businessType,
                      onChanged: (value) {
                        setState(() {
                          _businessType = value!;
                        });
                      },
                      dense: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              if (_businessType == 'individual') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_businessType == 'individual' &&
                              (value == null || value.isEmpty)) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_businessType == 'individual' &&
                              (value == null || value.isEmpty)) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (_businessType == 'company') ...[
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (_businessType == 'company' &&
                        (value == null || value.isEmpty)) {
                      return 'Business name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _businessUrlController,
                decoration: const InputDecoration(
                  labelText: 'Business Website (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.web),
                  hintText: 'https://example.com',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+1234567890',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _country,
                decoration: const InputDecoration(
                  labelText: 'Country *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(value: 'US', child: Text('United States')),
                  DropdownMenuItem(value: 'CA', child: Text('Canada')),
                  DropdownMenuItem(value: 'GB', child: Text('United Kingdom')),
                  DropdownMenuItem(value: 'AU', child: Text('Australia')),
                  DropdownMenuItem(value: 'DE', child: Text('Germany')),
                  DropdownMenuItem(value: 'FR', child: Text('France')),
                ],
                onChanged: (value) {
                  setState(() {
                    _country = value!;
                  });
                },
              ),
              const SizedBox(height: 32),

              const Text(
                'Bank Account Information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Why do we need bank account details?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Enable direct payments to your account\n'
                      '• Secure processing through Stripe\n'
                      '• Only last 4 digits will be visible to others\n'
                      '• Required for receiving marketplace payments',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankAccountNumberController,
                decoration: InputDecoration(
                  labelText: 'Bank Account Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.account_balance),
                  hintText: _country == 'US' ? 'Enter US bank account number' 
                           : _country == 'GB' ? 'Enter UK sort code + account number'
                           : 'Enter bank account number',
                  helperText: _country == 'US' ? 'US account numbers are typically 8-17 digits'
                             : _country == 'GB' ? 'Format: 123456 12345678 (sort code + account)'
                             : 'Account number format varies by country',
                ),
                keyboardType: TextInputType.number,
                maxLength: _country == 'GB' ? 14 : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankRoutingNumberController,
                decoration: InputDecoration(
                  labelText: _country == 'US' ? 'Routing Number (ABA)' 
                           : _country == 'GB' ? 'Sort Code'
                           : 'Routing Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.route),
                  hintText: _country == 'US' ? 'Enter 9-digit routing number'
                           : _country == 'GB' ? 'Enter 6-digit sort code'
                           : 'Enter routing/transit number',
                  helperText: _country == 'US' ? '9-digit number (e.g., 021000021)'
                             : _country == 'GB' ? '6-digit sort code (e.g., 123456)'
                             : 'Bank routing identifier',
                ),
                keyboardType: TextInputType.number,
                maxLength: _country == 'US' ? 9 : _country == 'GB' ? 6 : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankAccountHolderController,
                decoration: const InputDecoration(
                  labelText: 'Account Holder Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Leave empty to use business/personal name',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                  hintText: 'Enter bank name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetails(Map<String, dynamic> account) {
    final externalAccounts =
        account['external_accounts']?['data'] as List<dynamic>? ?? [];

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Connect Account Active',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Account ID', account['id'] ?? 'N/A'),
            _buildDetailRow('Type', account['type'] ?? 'N/A'),
            _buildDetailRow('Country', account['country'] ?? 'N/A'),
            _buildDetailRow('Email', account['email'] ?? 'N/A'),
            _buildDetailRow('Details Submitted',
                account['details_submitted'] == true ? 'Yes' : 'No'),
            _buildDetailRow('Charges Enabled',
                account['charges_enabled'] == true ? 'Yes' : 'No'),
            _buildDetailRow('Payouts Enabled',
                account['payouts_enabled'] == true ? 'Yes' : 'No'),
            if (externalAccounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Connected Bank Accounts',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...externalAccounts
                  .map((account) => _buildBankAccountCard(account))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard(Map<String, dynamic> bankAccount) {
    final status = bankAccount['status'] ?? 'pending';
    final isVerified = status == 'verified';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isVerified ? Icons.account_balance : Icons.schedule,
                  color: isVerified ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${bankAccount['bankName'] ?? bankAccount['bank_name'] ?? 'Bank'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isVerified ? Colors.green[100] : Colors.orange[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: isVerified ? Colors.green[800] : Colors.orange[800],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Account: ****${bankAccount['last4'] ?? ''}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${bankAccount['currency']?.toString().toUpperCase() ?? ''} • ${bankAccount['accountHolderType'] ?? bankAccount['account_holder_type'] ?? 'individual'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      if (!isVerified) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Verification pending - payments will be processed once verified',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isVerified)
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Ready to receive payments',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Account pending verification',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                    ),
                  ),
                Text(
                  'Note: To change bank details, contact support',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Connect Setup'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stripe Connect Setup',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect your bank account to receive payments directly. Complete the setup process to start accepting payments.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_errorMessage != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

            if (_errorMessage != null) const SizedBox(height: 16),

            if (_isLoading && _connectAccount == null)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading account information...'),
                    ],
                  ),
                ),
              ),

            if (!_isLoading) ...[
              if (_connectAccount != null)
                _buildAccountDetails(_connectAccount!)
              else
                _buildAccountForm(),
            ],

            const SizedBox(height: 24),

            if (!_isLoading) ...[
              if (_connectAccount == null)
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _createConnectAccount,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_card),
                  label: Text(_isLoading
                      ? 'Creating Account...'
                      : 'Create Stripe Connect Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (_connectAccount != null &&
                  _connectAccount!['charges_enabled'] != true) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final onboardingUrl = _connectAccount!['onboardingUrl'];
                    if (onboardingUrl != null) {
                      await _launchUrl(onboardingUrl);
                    } else {
                      setState(() {
                        _errorMessage =
                            'Onboarding URL not available. Please contact support.';
                      });
                    }
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Complete Account Setup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
              if (_connectAccount != null &&
                  _connectAccount!['charges_enabled'] == true) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your account is fully set up and ready to receive payments!',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Payments'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
