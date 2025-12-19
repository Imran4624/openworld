import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

//TODO add iput type Boolean, Number
//uncomment the code below after adding the input types

//./module.sh make flutter_boilerplate product product products products
//userId:String,name:String,description:String,category:String,brand:String,tags:String,sku:String,price:double,discountPrice:double,currency:String,isOnSale:bool,saleStart:String,saleEnd:String,bundleIds:String,stockQuantity:int,inStock:bool,minOrderQuantity:int,maxOrderQuantity:int,thumbnailUrl:String,media:String,rating:double,reviewCount:int,shippingWeightKg:double,dimensions:String,shipsFrom:String,estimatedDeliveryDays:int,warranty:String,returnPolicy:String,isReturnable:bool,isAvailable:bool,isFeatured:bool

final Map<String, Object> productQuestions = {
  'name': 'Create Product',
  'textOnSubmit': 'Product details saved successfully',
  'custom': {},
  'groups': [
    {
      'id': 'basic_info',
      'icon': Icons.info,
      'questions': [
        {
          'id': 'userId',
          'type': InputType.Text,
          'label': 'User ID',
          'placeholder': 'Enter the owner\'s user ID',
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'name',
          'type': InputType.Text,
          'label': 'Product Name',
          'placeholder': 'Enter product name',
          'editOrder': 2,
          'viewOrder': 2,
          'required': true,
          'info': '',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 1,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': true
        },
        {
          'id': 'description',
          'type': InputType.Text,
          'label': 'Description',
          'placeholder': 'Enter product description',
          'editOrder': 3,
          'viewOrder': 3,
          'required': false,
          'info': '',
          'searchable': 'ShowInAdvanceSearch',
          'searchOrder': 2,
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': true
        },
        {
          'id': 'category',
          'type': InputType.Text,
          'label': 'Category',
          'placeholder': 'Product category',
          'editOrder': 4,
          'viewOrder': 4,
          'required': true,
          'info': '',
          'searchable': 'ShowInAdvanceSearch',
          'searchOrder': 3,
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': true
        },
        {
          'id': 'brand',
          'type': InputType.Text,
          'label': 'Brand',
          'placeholder': 'Product brand',
          'editOrder': 5,
          'viewOrder': 5,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'tags',
          'type': InputType.Text,
          'label': 'Tags',
          'placeholder': 'Comma-separated tags',
          'editOrder': 6,
          'viewOrder': 6,
          'required': false,
          'info': '',
          'searchable': 'ShowInBasicSearch',
          'searchOrder': 4,
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': true
        },
        {
          'id': 'sku',
          'type': InputType.Text,
          'label': 'SKU',
          'placeholder': 'Stock Keeping Unit',
          'editOrder': 7,
          'viewOrder': 7,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
    {
      'id': 'pricing',
      'icon': Icons.attach_money,
      'questions': [
        {
          'id': 'price',
          'type': InputType.Number,
          'label': 'Price',
          'editOrder': 1,
          'viewOrder': 1,
          'required': true,
          'info': '',
          'searchable': 'ShowInAdvanceSearch',
          'searchOrder': 5,
          'isMultiSelect': false,
          'isRangeSelect': true,
          'isSearchable': false
        },
        {
          'id': 'discountPrice',
          'type': InputType.Number,
          'label': 'Discount Price',
          'editOrder': 2,
          'viewOrder': 2,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': true,
          'isSearchable': false
        },
        {
          'id': 'currency',
          'type': InputType.Text,
          'label': 'Currency',
          'editOrder': 3,
          'viewOrder': 3,
          'required': true,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'isOnSale',
          'type': InputType.Boolean,
          'label': 'Is On Sale?',
          'editOrder': 4,
          'viewOrder': 4,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'saleStart',
          'type': InputType.Date,
          'label': 'Sale Start',
          'editOrder': 5,
          'viewOrder': 5,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        },
        {
          'id': 'saleEnd',
          'type': InputType.Date,
          'label': 'Sale End',
          'editOrder': 6,
          'viewOrder': 6,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'isSearchable': false
        }
      ]
    },
    {
      'id': 'inventory',
      'icon': Icons.inventory,
      'questions': [
        {
          'id': 'bundleIds',
          'type': InputType.Text,
          'label': 'Bundle IDs',
          'placeholder': 'Comma-separated bundle IDs',
          'editOrder': 1,
          'viewOrder': 1,
          'required': false,
          'info': '',
          'searchable': 'None',
          'isMultiSelect': true,
          'isRangeSelect': false,
          'isSearchable': false
        },
            {
              'id': 'stockQuantity',
              'type': InputType.Number,
              'label': 'Stock Quantity',
              'editOrder': 2,
              'viewOrder': 2,
              'required': true,
              'info': '',
              'searchable': 'ShowInAdvanceSearch',
              'searchOrder': 6,
              'isMultiSelect': false,
              'isRangeSelect': true,
              'isSearchable': false
            },
            {
              'id': 'inStock',
              'type': InputType.Boolean,
              'label': 'In Stock?',
              'editOrder': 3,
              'viewOrder': 3,
              'required': true,
              'info': '',
              'searchable': 'ShowInBasicSearch',
              'searchOrder': 7,
              'isMultiSelect': false,
              'isRangeSelect': false,
              'isSearchable': false
            },
            {
              'id': 'minOrderQuantity',
              'type': InputType.Number,
              'label': 'Minimum Order Quantity',
              'editOrder': 4,
              'viewOrder': 4,
              'required': false,
              'info': '',
              'searchable': 'None',
              'isMultiSelect': false,
              'isRangeSelect': true,
              'isSearchable': false
            },
            {
              'id': 'maxOrderQuantity',
              'type': InputType.Number,
              'label': 'Maximum Order Quantity',
              'editOrder': 5,
              'viewOrder': 5,
              'required': false,
              'info': '',
              'searchable': 'None',
              'isMultiSelect': false,
              'isRangeSelect': true,
              'isSearchable': false
            },
        {
          'id': 'media',
          'icon': Icons.image,
          'questions': [
            {
              'id': 'media',
              'type': InputType.Document,
              'label': 'Gallery Media',
              'editOrder': 2,
              'viewOrder': 2,
              'required': false,
              'minValue': 1,
              'maxValue': 10,
              'allowedTypes':
                  'jpg,jpeg,png,gif,bmp,webp,heic,heif,tiff,tif,svg,mp4,mov',
              'showInLine': true,
              'searchable': 'None',
              'isMultiSelect': true,
              'isRangeSelect': false,
              'isSearchable': false
            }
          ]
        }
      ]
    }
  ]
};
