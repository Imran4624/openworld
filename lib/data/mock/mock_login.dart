import 'dart:convert';

import 'package:flutter_boilerplate/project_config.dart';

final kMockLogin = jsonEncode({
  "data": [
    {
      "permissions": ProjectConfig.mockLoginPermission,
      "notifications": {
        "email": ["all_notifications"]
      },
      "settings": {},
      "is_owner": true,
      "is_admin": true,
      "is_locked": false,
      "updated_at": 1598303136,
      "archived_at": 0,
      "created_at": 1598303136,
      "user": {
        "id": "VolejRejNm",
        "first_name": "Name not found",
        "last_name": "Antonette Skiles",
        "email": "small@example.com",
        "last_login": 1598615075,
        "created_at": 1598303136,
        "updated_at": 1598303136,
        "archived_at": 0,
        "is_deleted": false,
        "phone": "1-876-694-8636 x544",
        "email_verified_at": 1598303136,
        "signature": "",
        "custom_value1": "",
        "custom_value2": "",
        "custom_value3": "",
        "custom_value4": "",
        "oauth_provider_id": "",
        "company_user": {
          "permissions": "",
          "notifications": {
            "email": ["all_notifications"]
          },
          "settings": {},
          "is_owner": true,
          "is_admin": true,
          "is_locked": false,
          "updated_at": 1598303136,
          "archived_at": 0,
          "created_at": 1598303136
        }
      },
      "company": {
        "id": "VolejRejNm",
        "company_key":
            "50eb5y391ou3iaqowyrtpcpkrqut9q9f9r6d8nmtd9wynzt6u8xs4vxgiuks56xr",
        "update_products": true,
        "fill_products": true,
        "convert_products": false,
        "custom_surcharge_taxes1": false,
        "custom_surcharge_taxes2": false,
        "custom_surcharge_taxes3": false,
        "custom_surcharge_taxes4": false,
        "show_product_cost": false,
        "enable_product_cost": false,
        "show_product_details": true,
        "enable_product_quantity": true,
        "default_quantity": true,
        "custom_fields": {},
        "size_id": "",
        "industry_id": "",
        "first_month_of_year": "",
        "first_day_of_week": "",
        "subdomain": "",
        "portal_mode": "subdomain",
        "portal_domain": "",
        "mark_expenses_invoiceable": true,
        "mark_expenses_paid": true,
        "invoice_expense_documents": true,
        "invoice_task_documents": true,
        "invoice_task_timelog": true,
        "auto_start_tasks": true,
        "use_credits_payment": "",
        "settings": {},
        "enabled_tax_rates": 0,
        "enabled_modules": 32767,
        "updated_at": 1598303136,
        "archived_at": 0,
        "created_at": 1598303136,
        "slack_webhook_url": "",
        "google_analytics_url": "",
        "google_analytics_key": "",
        "enabled_item_tax_rates": 0,
        "client_can_register": false,
        "is_large": false,
        "enable_shop_api": false,
        "documents": [],
        "users": [],
        "designs": [],
        "clients": [],
        "invoices": [],
        "tax_rates": [],
        "products": [],
        "expenses": [],
        "vendors": [],
        "payments": [],
        "payment_terms": [],
        "groups": [],
        "company_gateways": [],
        "activities": [],
        "quotes": [],
        "credits": [],
        "projects": [],
        "tasks": [],
        "webhooks": [],
        "tokens_hashed": []
      },
      "token": {
        "id": "VolejRejNm",
        "user_id": "VolejRejNm",
        "token":
            "CNM1DCvOw3P5D8yg7ItWZpk7nT4Pq8g5pt3Vl8jteGHAGm2nG3LAIJRbKGGlzIFF",
        "name": "test token",
        "is_system": true,
        "updated_at": 1598303136,
        "archived_at": 0,
        "created_at": 1598303136,
        "is_deleted": false
      },
      "account": {
        "id": "VolejRejNm",
        "default_url": "https://staging.invoicing.co/",
        "plan": "",
        "plan_term": "",
        "plan_started": "",
        "plan_paid": "",
        "plan_expires": "",
        "user_agent": "",
        "payment_id": "",
        "trial_started": "",
        "trial_plan": "",
        "plan_price": 0,
        "num_users": 1,
        "utm_source": "",
        "utm_medium": "",
        "utm_content": "",
        "utm_term": "",
        "referral_code": "",
        "latest_version": "5.0.13",
        "current_version": "5.0.13",
        "updated_at": 1598572804,
        "archived_at": 0,
        "report_errors": true
      }
    }
  ],
  "meta": {
    "pagination": {
      "total": 1,
      "count": 1,
      "per_page": 20,
      "current_page": 1,
      "total_pages": 1,
      "links": []
    }
  },
  "static": {
    "banks": [],
    "countries": [],
    "currencies": [
      {
        "id": "2",
        "name": "British Pound",
        "symbol": "\u00a3",
        "precision": 2,
        "thousand_separator": ",",
        "decimal_separator": ".",
        "code": "GBP",
        "swap_currency_symbol": false,
        "exchange_rate": 0.75759
      }
    ],
    "date_formats": [],
    "datetime_formats": [],
    "gateways": [],
    "gateway_types": [],
    "industries": [],
    "languages": [
      {"id": "1", "name": "English", "locale": "en"},
      {"id": "20", "name": "English - United Kingdom", "locale": "en_GB"}
    ],
    "sizes": [],
    "timezones": []
  }
});
