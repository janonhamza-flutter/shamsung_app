import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': _en, 'ar_SA': _ar};

  // ─────────────────────────────────────────────────────────────────────────
  // ENGLISH
  // ─────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    // App
    'app_name': 'SHAMSOUNG',
    'app_description': 'Smart Maintenance System',

    // Splash
    'get_started': 'Get Started',

    // Onboarding
    'onboarding_title_1': 'Welcome to Shamsung',
    'onboarding_subtitle_1':
        'Fast and reliable maintenance services at your fingertips.',
    'onboarding_title_2': 'Track Your Orders',
    'onboarding_subtitle_2':
        'Follow your maintenance requests and service progress easily.',
    'onboarding_title_3': 'Get Started',
    'onboarding_subtitle_3':
        'Book services, manage your account, and enjoy a seamless experience.',

    // Auth
    'login': 'Login',
    'sign_up': 'Sign Up',
    'email': 'Email',
    'password': 'Password',
    'password_confirmation': 'Confirm Password',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'mobile': 'Mobile',
    'forget_password': 'Forget Password?',
    'dont_have_account': "Don't have an account?",
    'already_have_account': 'Already have an account?',
    'verify_phone': 'Verify Phone Number',
    'enter_phone': 'Enter your phone number to receive OTP',
    'phone_hint': 'Phone Number ex: +963 999999999',
    'send_otp': 'Send OTP',
    'verify_code': 'Verification Code',
    'code_sent_to': 'Code sent to',
    'enter_otp': 'Enter the OTP sent to your number',
    'didnt_receive_code': "Didn't receive the code?",
    'resend_otp': 'Resend OTP',
    'resend_in': 'Resend in',
    'seconds': 'seconds',
    'verify': 'Verify',
    'birth_date_hint': 'Birth Date (ex: 2002-01-03)',

    // Validation
    'email_required': 'Email is required',
    'password_required': 'Password is required',
    'full_name_required': 'Full name is required',
    'mobile_required': 'Mobile number is required',
    'invalid_email': 'Invalid email address',
    'password_too_short': 'Password must be at least 8 characters',

    // Buttons
    'save': 'Save',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'logout': 'Logout',
    'next': 'Next',
    'back': 'Back',
    'delete': 'Delete',

    // API / Server
    'server_error': 'Server error',
    'connection_error': 'Connection failed',
    'something_went_wrong': 'Something went wrong',

    // Loading
    'loading': 'Loading...',

    // Success
    'login_success': 'Login successful',
    'signup_success': 'Account created successfully',

    // Failures
    'login_failed': 'Login failed',
    'signup_failed': 'Signup failed',

    // Delete Account
    'delete_account': 'Delete Account',
    'sure_delete': 'Are you sure you want to delete your account?',
    'confirm_delete': 'Delete',
    'cancel_delete': 'Cancel',

    // Profile
    'profile': 'Profile',
    'account': 'Account',
    'preferences': 'Preferences',
    'more': 'More',
    'my_orders': 'My Orders',
    'notifications': 'Notifications',
    'language': 'Language',
    'about_app': 'About App',
    'logout_confirm': 'Are you sure you want to logout?',

    // Home
    'home': 'Home',
    'press_back_exit': 'Press again to exit',
    'quick_actions': 'Quick Actions',
    'hello': 'Hello',
    'welcome_back': 'Welcome back to ShamSung',
    'maintenance': 'Maintenance',
    'store': 'Store',
    'consultations': 'Consultations',
    'nearest_shop': 'Nearest Shop',
    'my_requests': 'My Requests',
    'new_request': 'New Request',
    'deliveries': 'Deliveries',

    // Bottom Nav
    'nav_home': 'Home',
    'nav_repairs': 'Repairs',
    'nav_delivery': 'Delivery',
    'nav_profile': 'Profile',

    // Promo Carousel
    'promo_tag_official': 'Official Service',
    'promo_headline_official': 'Certified Samsung\nRepair Center',
    'promo_body_official':
        'Every repair backed by genuine parts\nand expert technicians.',
    'promo_tag_fast': 'Fast Turnaround',
    'promo_headline_fast': 'Same-Day Repairs\nFor Most Issues',
    'promo_body_fast':
        'Screen, battery, and camera repairs\ncompleted while you wait.',
    'promo_tag_ai': 'AI-Powered Support',
    'promo_headline_ai': 'Get Expert Advice\nAnytime, Instantly',
    'promo_body_ai':
        'Chat with our AI or a live technician\nbefore you even visit the shop.',
    'promo_tag_near': 'Near You',
    'promo_headline_near': 'Find the Closest\nSamsung Shop',
    'promo_body_near':
        'Locate your nearest service center\nin seconds with live directions.',
    'promo_tag_shop': 'Shop Now',
    'promo_headline_shop': 'Accessories',
    'promo_body_shop':
        'Upgrade your device with our\nexclusive accessories — shop now!',

    // Quick Action Cards
    'action_request_repair': 'Request\nRepair',
    'action_request_repair_sub': 'Submit a maintenance request',
    'action_find_shop': 'Find\nShop',
    'action_find_shop_sub': 'Nearest center',
    'action_ask_ai': 'Ask\nAI',
    'action_ask_ai_sub': 'Expert advice',
    'action_browse_store': 'Browse\nStore',
    'action_browse_store_sub': 'Accessories & parts',

    // Notifications
    'no_notifications': 'No notifications yet',
    'all_caught_up': "You're all caught up!",
    'mark_all_read': 'Mark all read',
    'loading_notifications': 'Loading notifications...',
    'refresh': 'Refresh',

    // Time formatting
    'just_now': 'Just now',
    'time_days_ago': '',
    'time_days': 'd ago',
    'time_hours_ago': '',
    'time_hours': 'h ago',
    'time_minutes_ago': '',
    'time_minutes': 'm ago',

    // Maintenance Requests
    'new_maintenance_request': 'New Maintenance Request',
    'create_request': 'Create Request',
    'submit_repair_request': 'Submit a Repair Request',
    'submit_repair_request_sub':
        'Our technicians will review your request and provide an estimate',
    'device_information': 'Device Information',
    'device_model': 'Device Model',
    'device_model_hint': 'e.g. Samsung Galaxy S24 Ultra',
    'problem_description': 'Problem Description',
    'describe_issue': 'Describe the issue',
    'describe_issue_hint': "Describe what's wrong with your device...",
    'select_shop': 'Select Shop',
    'loading_shops': 'Loading shops...',
    'no_shops_available': 'No shops available',
    'select_a_shop': 'Select a shop',
    'selected_branch': 'Selected Branch',
    'nearest': 'Nearest',
    'submit_request': 'Submit Request',
    'loading_requests': 'Loading requests...',
    'retry': 'Retry',
    'no_requests_yet': 'No Requests Yet',
    'no_requests_hint':
        'Submit your first maintenance request\nand track it here',
    'request_details': 'Request Details',
    'cancel_request': 'Cancel Request',
    'cancel_request_title': 'Cancel Request?',
    'cancel_request_body':
        'This action cannot be undone. The request will be permanently cancelled.',
    'keep_it': 'Keep It',
    'loading_details': 'Loading details...',
    'rejection_reason': 'Rejection Reason',
    'tracking_number': 'Tracking Number',
    'copied': 'Copied',
    'tracking_number_copied': 'Tracking number copied',
    'repair_estimate': 'Repair Estimate',
    'estimated_cost': 'Estimated Cost',
    'estimated_days': 'Estimated Days',
    'day': 'day',
    'days': 'days',
    'shop_information': 'Shop Information',
    'shop_name': 'Shop Name',
    'address': 'Address',
    'phone': 'Phone',
    'parts': 'Parts',
    'qty': 'Qty',
    'total_parts_cost': 'Total Parts Cost',
    'required': 'Required',
    'delete_request': 'Delete Request',
    'delete_request_confirm': 'Are you sure you want to delete this request?',
    'no': 'No',
    // Status labels
    'status_pending': 'Pending',
    'status_in_progress': 'In Progress',
    'status_repairing': 'Repairing',
    'status_completed': 'Completed',
    'status_done': 'Done',
    'status_approved': 'Approved',
    'status_rejected': 'Rejected',
    'status_cancelled': 'Cancelled',
    'status_awaiting_approval': 'Awaiting Approval',
    'status_awaiting_your_approval': 'Awaiting Your Approval',
    'status_pending_review': 'Pending Review',
    'status_under_inspection': 'Under Inspection',
    'status_under_inspection_detail': 'Under Inspection',
    // Approve / Reject
    'review_and_approve': 'Review & Approve',
    'approve_sheet_sub': 'Select parts and choose payment method',
    'reject': 'Reject',
    'technician_waiting_approval':
        'The technician is waiting for your approval to start the repair',
    'select_parts': 'Select Parts',
    'required_parts_note':
        'Required parts are mandatory and cannot be deselected',
    'payment_method': 'Payment Method',
    'payment_cash_on_delivery': 'Cash on Delivery',
    'payment_pay_after_service': 'Pay After Service',
    'selected_total': 'Selected Total',
    'pickup_location': 'Pickup Location',
    'location_selected': 'Location Selected',
    'set_pickup_location': 'Set Pickup Location from Map',
    'confirm_approval': 'Confirm Approval',
    'select_location_first': 'Select Location First',
    'reject_request': 'Reject Request',
    'reject_request_sub': "Tell us why you're rejecting",
    'quick_reasons': 'Quick Reasons',
    'write_own_reason': 'Or write your own reason...',
    'confirm_reject': 'Confirm Reject',
    'reject_preset_1': 'Price is too high',
    'reject_preset_2': 'Found another service',
    'reject_preset_3': 'Problem resolved itself',
    'reject_preset_4': 'Changed my mind',

    // Store
    'store_header_title': 'Samsung Accessories',
    'store_header_sub': 'Original products at the best prices',
    'store_showing_from': 'Showing products from',
    'products': 'Products',
    'loading_products': 'Loading products...',
    'no_products': 'No products available',
    'search_product': 'Search for a product...',
    'product_details': 'Product Details',
    'loading_product': 'Loading product...',
    'description': 'Description',
    'in_stock': 'Available',
    'add_to_cart': 'Add to Cart',
    'adding_to_cart': 'Adding...',
    'added_to_cart': 'Added to Cart',
    'view_cart': 'View Cart',
    // Cart
    'cart': 'Cart',
    'loading_cart': 'Loading cart...',
    'cart_empty': 'Cart is Empty',
    'cart_empty_sub': 'Add products from the store',
    'browse_store': 'Browse Store',
    'items_count': 'Items Count',
    'pieces': 'pcs',
    'item_total': 'Total',
    'place_order': 'Place Order',
    // Checkout
    'checkout': 'Checkout',
    'order_summary': 'Order Summary',
    'delivery_location': 'Delivery Location',
    'set_delivery_location': 'Set Delivery Location from Map',
    'select_delivery_location_first': 'Select Delivery Location First',
    'payment_cod_sub': 'Pay cash when you receive your order',
    'payment_pas_sub': 'Pay electronically after receiving the service',
    'order_confirmed': 'Order Confirmed!',
    'order_number': 'Order Number',
    'center_name': 'Center Name',
    'checkout_confirm_cod':
        'We will contact you to confirm the delivery time.\nCash on delivery.',
    'checkout_confirm_pas':
        'We will contact you after the service is complete for payment.',
    'ok': 'OK',

    // Orders
    'my_deliveries': 'My Deliveries',
    'order_status': 'Order Status',
    'order_date': 'Order Date',
    'total': 'Total',
    'no_orders_yet': 'No Orders Yet',
    'no_orders_hint': 'Start shopping and your orders will appear here',
    'loading_orders': 'Loading orders...',
    'product': 'Product',

    // Deliveries
    'delivery_number': 'Delivery No.',
    'delivery_branch': 'Branch',
    'delivery_worker': 'Delivery Worker',
    'notes': 'Notes',
    'not_assigned_yet': 'Not assigned yet',
    'estimated_time': 'Estimated Time',
    'not_set_yet': 'Not set yet',
    'created_at': 'Created At',
    'confirmation_code': 'Confirmation Code',
    'track_deliveries': 'Track Your Deliveries',
    'all_deliveries_here': 'All your delivery orders in one place',
    'loading_deliveries': 'Loading deliveries...',
    'no_deliveries_yet': 'No Deliveries Yet',
    'no_deliveries_hint': 'All your delivery orders will appear here',
    'deliveries_count_label': 'delivery',
    // Delivery status
    'delivery_status_delivered': 'Delivered',
    'delivery_status_accepted': 'Accepted',
    'delivery_status_pending': 'Pending',
    'delivery_status_cancelled': 'Cancelled',
    // Delivery types
    'delivery_type_pickup': 'Device Pickup',
    'delivery_type_accessory': 'Accessory Delivery',
    'delivery_type_device': 'Device Delivery',

    // Consultation
    'create_consultation': 'Create Consultation',
    'type_message': 'Type a message...',
    'send': 'Send',
    'no_consultations': 'No consultations yet',

    // About
    'about': 'About',
    'version': 'Version',
    'contact_us': 'Contact Us',
    'about_app_title': 'About App',
    'about_shamsung_label': 'About Shamsung',
    'about_shamsung_desc':
        'Shamsung is your all-in-one Samsung service platform. '
        'Submit maintenance requests, track repairs in real time, '
        'shop for genuine accessories, and get instant AI-powered '
        'support — all from one place.',
    'key_features': 'Key Features',
    'feature_maintenance': 'Maintenance Requests',
    'feature_maintenance_desc': 'Submit and track repair requests easily',
    'feature_store': 'Online Store',
    'feature_store_desc': 'Shop for accessories and spare parts',
    'feature_ai': 'AI Consultations',
    'feature_ai_desc': 'Get expert advice anytime',
    'feature_nearest': 'Nearest Shops',
    'feature_nearest_desc': 'Find the closest service center',
    'app_info': 'App Info',
    'app_info_name': 'App Name',
    'app_info_platform': 'Platform',
    'app_info_platform_value': 'Android',
    'app_info_version': 'Version',
    'app_footer': 'Shamsung. All rights reserved © 2026 .',

    // Currency
    'currency': 'SP',
    'english': 'English',
    'arabic': 'Arabic',
    'language_changed': 'Language changed successfully',
    'select_language': 'Select Language',
    'appearance': 'Appearance',
    'select_theme': 'Select Theme',
    'theme_light': 'Light',
    'theme_dark': 'Dark',
    'theme_system': 'System Default',

    // Nearest Shop Page
    'nearest_shops_title': 'Nearest Shops',
    'detecting_location': 'Detecting your location...',
    'finding_nearest_shops': 'Finding the nearest Samsung shops',
    'could_not_get_location': 'Could not get your location',
    'enable_location_services':
        'Make sure location services are enabled and permission is granted.',
    'try_again': 'Try Again',
    'no_shops_found_nearby': 'No shops found nearby',
    'no_shops_near_location':
        'There are no Samsung service centers near your current location.',
    'shops_found_near_you': 'shop found near you',
    'shops_found_near_you_plural': 'shops found near you',
    'shop_open': 'Open',
    'shop_closed': 'Closed',
    'branch_unavailable': 'This branch is currently unavailable',
    'request_repair': 'Request Repair',
    'shop_here': 'Shop Here',
    'distance_away_m': 'm away',
    'distance_away_km': 'km away',

    // Consultation List Page
    'my_consultations': 'My Consultations',
    'new_consultation_fab': 'New',
    'loading_consultations': 'Loading consultations...',
    'no_consultations_yet': 'No consultations yet',
    'no_consultations_hint': 'Ask AI or a technician\nabout your device issue',
    'start_consultation': 'Start a Consultation',

    // Consultation Chat Page
    'new_consultation': 'New Consultation',
    'ai_assistant': 'AI Assistant',
    'technician': 'Technician',
    'ask_question_below': 'Ask your question below',
    'choose_type_hint':
        'Choose AI for instant answers\nor Technician for expert help',
    'write_message_hint': 'Write your message…',
    'awaiting_technician_reply':
        'Waiting for the technician\'s reply\nThank you for using this service 🙏',

    // Consultation Card
    'consultation_type_ai': 'AI',
    'consultation_type_technician': 'Technician',
    'consultation_status_answered': 'Answered',
    'consultation_status_pending': 'Pending',
    'awaiting_ai_response': 'Awaiting AI response…',
    'awaiting_technician_response': 'Awaiting technician reply…',
    'delete_consultation': 'Delete Consultation',
    'delete_consultation_confirm':
        'Are you sure you want to delete this consultation?',

    // Consultation Type Selector
    'ask_ai': 'Ask AI',
    'ask_technician': 'Ask Technician',

    // Controller errors
    'enter_question_first': 'Please enter your question first',
    'failed_to_send': '⚠ Failed to send. Please try again.',
  };

  // ─────────────────────────────────────────────────────────────────────────
  // ARABIC
  // ─────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _ar = {
    // App
    'app_name': 'شامسونج',
    'app_description': 'نظام الصيانة الذكي',

    // Splash
    'get_started': 'ابدأ الآن',

    // Onboarding
    'onboarding_title_1': 'مرحباً بك في شامسونج',
    'onboarding_subtitle_1': 'خدمات صيانة سريعة وموثوقة في متناول يدك.',
    'onboarding_title_2': 'تتبع طلباتك',
    'onboarding_subtitle_2': 'تابع طلبات الصيانة وتقدم الخدمة بسهولة.',
    'onboarding_title_3': 'ابدأ الآن',
    'onboarding_subtitle_3': 'احجز الخدمات، وأدر حسابك، واستمتع بتجربة سلسة.',

    // Auth
    'login': 'تسجيل الدخول',
    'sign_up': 'إنشاء حساب',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'password_confirmation': 'تأكيد كلمة المرور',
    'first_name': 'الاسم الأول',
    'last_name': 'اسم العائلة',
    'mobile': 'رقم الجوال',
    'forget_password': 'نسيت كلمة المرور؟',
    'dont_have_account': 'ليس لديك حساب؟',
    'already_have_account': 'لديك حساب بالفعل؟',
    'verify_phone': 'التحقق من رقم الهاتف',
    'enter_phone': 'أدخل رقم هاتفك لاستلام رمز التحقق',
    'phone_hint': 'رقم الهاتف مثال: +963 999999999',
    'send_otp': 'إرسال رمز التحقق',
    'verify_code': 'رمز التحقق',
    'code_sent_to': 'تم إرسال الرمز إلى',
    'enter_otp': 'أدخل رمز التحقق المرسل إلى رقمك',
    'didnt_receive_code': 'لم تستلم الرمز؟',
    'resend_otp': 'إعادة إرسال الرمز',
    'resend_in': 'إعادة الإرسال خلال',
    'seconds': 'ثانية',
    'verify': 'تحقق',
    'birth_date_hint': 'تاريخ الميلاد (مثال: 2002-01-03)',

    // Validation
    'email_required': 'البريد الإلكتروني مطلوب',
    'password_required': 'كلمة المرور مطلوبة',
    'full_name_required': 'الاسم الكامل مطلوب',
    'mobile_required': 'رقم الجوال مطلوب',
    'invalid_email': 'البريد الإلكتروني غير صحيح',
    'password_too_short': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',

    // Buttons
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'logout': 'تسجيل الخروج',
    'next': 'التالي',
    'back': 'رجوع',
    'delete': 'حذف',

    // API / Server
    'server_error': 'خطأ في الخادم',
    'connection_error': 'فشل الاتصال',
    'something_went_wrong': 'حدث خطأ ما',

    // Loading
    'loading': 'جاري التحميل...',

    // Success
    'login_success': 'تم تسجيل الدخول بنجاح',
    'signup_success': 'تم إنشاء الحساب بنجاح',

    // Failures
    'login_failed': 'فشل تسجيل الدخول',
    'signup_failed': 'فشل إنشاء الحساب',

    // Delete Account
    'delete_account': 'حذف الحساب',
    'sure_delete': 'هل أنت متأكد أنك تريد حذف حسابك؟',
    'confirm_delete': 'حذف',
    'cancel_delete': 'إلغاء',

    // Profile
    'profile': 'الملف الشخصي',
    'account': 'الحساب',
    'preferences': 'التفضيلات',
    'more': 'المزيد',
    'my_orders': 'طلباتي',
    'notifications': 'الإشعارات',
    'language': 'اللغة',
    'about_app': 'عن التطبيق',
    'logout_confirm': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',

    // Home
    'home': 'الرئيسية',
    'press_back_exit': 'اضغط مرة أخرى للخروج',
    'quick_actions': 'الإجراءات السريعة',
    'hello': 'مرحباً',
    'welcome_back': 'مرحباً بعودتك إلى شامسونج',
    'maintenance': 'الصيانة',
    'store': 'المتجر',
    'consultations': 'الاستشارات',
    'nearest_shop': 'أقرب متجر',
    'my_requests': 'طلباتي',
    'new_request': 'طلب جديد',
    'deliveries': 'التوصيل',

    // Bottom Nav
    'nav_home': 'الرئيسية',
    'nav_repairs': 'الإصلاح',
    'nav_delivery': 'التوصيل',
    'nav_profile': 'الملف',

    // Promo Carousel
    'promo_tag_official': 'خدمة رسمية',
    'promo_headline_official': 'مركز إصلاح شامسونج\nالمعتمد',
    'promo_body_official': 'كل إصلاح مدعوم بقطع أصلية\nوفنيين متخصصين.',
    'promo_tag_fast': 'إنجاز سريع',
    'promo_headline_fast': 'إصلاح في نفس اليوم\nلمعظم المشكلات',
    'promo_body_fast': 'إصلاح الشاشة والبطارية والكاميرا\nبينما تنتظر.',
    'promo_tag_ai': 'دعم بالذكاء الاصطناعي',
    'promo_headline_ai': 'احصل على مشورة خبراء\nفي أي وقت وفوراً',
    'promo_body_ai': 'تحدث مع الذكاء الاصطناعي أو فني مباشر\nقبل زيارة المتجر.',
    'promo_tag_near': 'بالقرب منك',
    'promo_headline_near': 'ابحث عن أقرب\nمتجر شامسونج',
    'promo_body_near': 'حدد أقرب مركز خدمة\nفي ثوانٍ مع الاتجاهات المباشرة.',
    'promo_tag_shop': 'تسوق الآن',
    'promo_headline_shop': 'الإكسسوارات',
    'promo_body_shop': 'طوّر جهازك مع إكسسواراتنا\nالحصرية — تسوق الآن!',

    // Quick Action Cards
    'action_request_repair': 'طلب\nإصلاح',
    'action_request_repair_sub': 'أرسل طلب صيانة',
    'action_find_shop': 'ابحث\nعن متجر',
    'action_find_shop_sub': 'أقرب مركز',
    'action_ask_ai': 'اسأل\nالذكاء',
    'action_ask_ai_sub': 'نصيحة الخبراء',
    'action_browse_store': 'تصفح\nالمتجر',
    'action_browse_store_sub': 'إكسسوارات وقطع غيار',

    // Notifications
    'no_notifications': 'لا توجد إشعارات بعد',
    'all_caught_up': 'أنت على اطلاع بكل شيء!',
    'mark_all_read': 'تحديد الكل كمقروء',
    'loading_notifications': 'جاري تحميل الإشعارات...',
    'refresh': 'تحديث',

    // Time formatting
    'just_now': 'الآن',
    'time_days_ago': 'منذ',
    'time_days': 'يوم',
    'time_hours_ago': 'منذ',
    'time_hours': 'ساعة',
    'time_minutes_ago': 'منذ',
    'time_minutes': 'دقيقة',

    // Maintenance Requests
    'new_maintenance_request': 'طلب صيانة جديد',
    'create_request': 'إنشاء طلب',
    'submit_repair_request': 'تقديم طلب إصلاح',
    'submit_repair_request_sub': 'سيراجع فنيونا طلبك ويقدمون تقديراً للتكلفة',
    'device_information': 'معلومات الجهاز',
    'device_model': 'طراز الجهاز',
    'device_model_hint': 'مثال: Samsung Galaxy S24 Ultra',
    'problem_description': 'وصف المشكلة',
    'describe_issue': 'صف المشكلة',
    'describe_issue_hint': 'صف ما يعانيه جهازك...',
    'select_shop': 'اختر المتجر',
    'loading_shops': 'جاري تحميل المتاجر...',
    'no_shops_available': 'لا توجد متاجر متاحة',
    'select_a_shop': 'اختر متجراً',
    'selected_branch': 'الفرع المختار',
    'nearest': 'الأقرب',
    'submit_request': 'إرسال الطلب',
    'loading_requests': 'جاري تحميل الطلبات...',
    'retry': 'إعادة المحاولة',
    'no_requests_yet': 'لا توجد طلبات بعد',
    'no_requests_hint': 'أرسل طلب الصيانة الأول\nوتابعه من هنا',
    'request_details': 'تفاصيل الطلب',
    'cancel_request': 'إلغاء الطلب',
    'cancel_request_title': 'إلغاء الطلب؟',
    'cancel_request_body':
        'لا يمكن التراجع عن هذا الإجراء. سيُلغى الطلب نهائياً.',
    'keep_it': 'الاحتفاظ به',
    'loading_details': 'جاري تحميل التفاصيل...',
    'rejection_reason': 'سبب الرفض',
    'tracking_number': 'رقم التتبع',
    'copied': 'تم النسخ',
    'tracking_number_copied': 'تم نسخ رقم التتبع',
    'repair_estimate': 'تقدير الإصلاح',
    'estimated_cost': 'التكلفة المقدرة',
    'estimated_days': 'المدة المقدرة',
    'day': 'يوم',
    'days': 'أيام',
    'shop_information': 'معلومات المتجر',
    'shop_name': 'اسم المتجر',
    'address': 'العنوان',
    'phone': 'الهاتف',
    'parts': 'القطع',
    'qty': 'الكمية',
    'total_parts_cost': 'إجمالي تكلفة القطع',
    'required': 'مطلوب',
    'delete_request': 'حذف الطلب',
    'delete_request_confirm': 'هل أنت متأكد أنك تريد حذف هذا الطلب؟',
    'no': 'لا',
    // Status labels
    'status_pending': 'قيد الانتظار',
    'status_in_progress': 'قيد التنفيذ',
    'status_repairing': 'جاري الإصلاح',
    'status_completed': 'مكتمل',
    'status_done': 'تم',
    'status_approved': 'موافق عليه',
    'status_rejected': 'مرفوض',
    'status_cancelled': 'ملغي',
    'status_awaiting_approval': 'في انتظار الموافقة',
    'status_awaiting_your_approval': 'في انتظار موافقتك',
    'status_pending_review': 'قيد المراجعة',
    'status_under_inspection': 'قيد الفحص',
    'status_under_inspection_detail': 'جاري فحص الجهاز',
    // Approve / Reject
    'review_and_approve': 'مراجعة والموافقة',
    'approve_sheet_sub': 'اختر القطع وطريقة الدفع',
    'reject': 'رفض',
    'technician_waiting_approval': 'الفني ينتظر موافقتك للبدء في الإصلاح',
    'select_parts': 'اختر القطع',
    'required_parts_note': 'القطع المطلوبة إلزامية ولا يمكن إلغاء تحديدها',
    'payment_method': 'طريقة الدفع',
    'payment_cash_on_delivery': 'الدفع عند الاستلام',
    'payment_pay_after_service': 'الدفع بعد الخدمة',
    'selected_total': 'الإجمالي المختار',
    'pickup_location': 'موقع الاستلام',
    'location_selected': 'تم تحديد الموقع',
    'set_pickup_location': 'حدد موقع الاستلام من الخريطة',
    'confirm_approval': 'تأكيد الموافقة',
    'select_location_first': 'حدد الموقع أولاً',
    'reject_request': 'رفض الطلب',
    'reject_request_sub': 'أخبرنا سبب رفضك',
    'quick_reasons': 'أسباب سريعة',
    'write_own_reason': 'أو اكتب سببك الخاص...',
    'confirm_reject': 'تأكيد الرفض',
    'reject_preset_1': 'السعر مرتفع جداً',
    'reject_preset_2': 'وجدت خدمة أخرى',
    'reject_preset_3': 'المشكلة حُلت من تلقاء نفسها',
    'reject_preset_4': 'غيّرت رأيي',

    // Store
    'store_header_title': 'إكسسوارات شامسونج',
    'store_header_sub': 'منتجات أصلية بأفضل الأسعار',
    'store_showing_from': 'عرض منتجات من',
    'products': 'المنتجات',
    'loading_products': 'جاري تحميل المنتجات...',
    'no_products': 'لا توجد منتجات متاحة',
    'search_product': 'ابحث عن منتج...',
    'product_details': 'تفاصيل المنتج',
    'loading_product': 'جاري تحميل المنتج...',
    'description': 'الوصف',
    'in_stock': 'متوفر في المخزون',
    'out_of_stock': 'نفد المخزون',
    'add_to_cart': 'أضف إلى السلة',
    'adding_to_cart': 'جاري الإضافة...',
    'added_to_cart': 'تمت الإضافة إلى السلة',
    'view_cart': 'عرض السلة',
    // Cart
    'cart': 'سلة المشتريات',
    'loading_cart': 'جاري تحميل السلة...',
    'cart_empty': 'السلة فارغة',
    'cart_empty_sub': 'أضف منتجات من المتجر',
    'browse_store': 'تصفح المتجر',
    'items_count': 'عدد المنتجات',
    'pieces': 'قطعة',
    'item_total': 'الإجمالي',
    'place_order': 'تأكيد الطلب',
    // Checkout
    'checkout': 'تأكيد الطلب',
    'order_summary': 'ملخص الطلب',
    'delivery_location': 'موقع التسليم',
    'set_delivery_location': 'تحديد موقع التسليم من الخريطة',
    'select_delivery_location_first': 'حدد موقع التسليم أولاً',
    'payment_cod_sub': 'ادفع نقداً عند استلام طلبك',
    'payment_pas_sub': 'ادفع إلكترونياً بعد استلام الخدمة',
    'order_confirmed': 'تم تأكيد طلبك!',
    'order_number': 'رقم الطلب',
    'center_name': 'اسم المركز',
    'checkout_confirm_cod':
        'سيتم التواصل معك لتأكيد موعد التسليم.\nالدفع عند الاستلام.',
    'checkout_confirm_pas': 'سيتم التواصل معك بعد اكتمال الخدمة للدفع.',
    'ok': 'حسناً',

    // Orders
    'my_deliveries': 'توصيلاتي',
    'order_status': 'حالة الطلب',
    'order_date': 'تاريخ الطلب',
    'total': 'الإجمالي',
    'no_orders_yet': 'لا توجد طلبات حتى الآن',
    'no_orders_hint': 'ابدأ التسوق وستظهر طلباتك هنا',
    'loading_orders': 'جاري تحميل الطلبات...',
    'product': 'منتج',

    // Deliveries
    'delivery_number': 'رقم التوصيل',
    'delivery_branch': 'الفرع',
    'delivery_worker': 'عامل التوصيل',
    'notes': 'الملاحظات',
    'not_assigned_yet': 'لم يُعيَّن بعد',
    'estimated_time': 'الوقت المقدر',
    'not_set_yet': 'لم يُحدد بعد',
    'created_at': 'تاريخ الإنشاء',
    'confirmation_code': 'رمز التأكيد',
    'track_deliveries': 'تتبع توصيلاتك',
    'all_deliveries_here': 'جميع طلبات التوصيل الخاصة بك في مكان واحد',
    'loading_deliveries': 'جاري تحميل التوصيلات...',
    'no_deliveries_yet': 'لا توجد توصيلات حتى الآن',
    'no_deliveries_hint': 'ستظهر هنا جميع طلبات التوصيل الخاصة بك',
    'deliveries_count_label': 'توصيلة',
    // Delivery status
    'delivery_status_delivered': 'تم التسليم',
    'delivery_status_accepted': 'مقبول',
    'delivery_status_pending': 'قيد الانتظار',
    'delivery_status_cancelled': 'ملغى',
    // Delivery types
    'delivery_type_pickup': 'استلام جهاز',
    'delivery_type_accessory': 'توصيل إكسسوار',
    'delivery_type_device': 'توصيل جهاز',

    // Consultation
    'create_consultation': 'إنشاء استشارة',
    'type_message': 'اكتب رسالة...',
    'send': 'إرسال',
    'no_consultations': 'لا توجد استشارات بعد',

    // About
    'about': 'عن التطبيق',
    'version': 'الإصدار',
    'contact_us': 'تواصل معنا',
    'about_app_title': 'عن التطبيق',
    'about_shamsung_label': 'عن شامسونج',
    'about_shamsung_desc':
        'شامسونج هي منصتك الشاملة لخدمات سامسونج. '
        'قدّم طلبات الصيانة، وتابع الإصلاحات في الوقت الفعلي، '
        'وتسوق للإكسسوارات الأصلية، واحصل على دعم فوري بالذكاء الاصطناعي '
        '— كل ذلك من مكان واحد.',
    'key_features': 'المميزات الرئيسية',
    'feature_maintenance': 'طلبات الصيانة',
    'feature_maintenance_desc': 'قدّم وتابع طلبات الإصلاح بسهولة',
    'feature_store': 'المتجر الإلكتروني',
    'feature_store_desc': 'تسوق للإكسسوارات وقطع الغيار',
    'feature_ai': 'استشارات الذكاء الاصطناعي',
    'feature_ai_desc': 'احصل على نصائح الخبراء في أي وقت',
    'feature_nearest': 'أقرب المتاجر',
    'feature_nearest_desc': 'ابحث عن أقرب مركز خدمة',
    'app_info': 'معلومات التطبيق',
    'app_info_name': 'اسم التطبيق',
    'app_info_platform': 'المنصة',
    'app_info_platform_value': 'أندرويد',
    'app_info_version': 'الإصدار',
    'app_footer': 'شامسونج. جميع الحقوق محفوظة © 2026 .',

    // Currency
    'currency': 'ل.س',
    'english': 'الإنجليزية',
    'arabic': 'العربية',
    'language_changed': 'تم تغيير اللغة بنجاح',
    'select_language': 'اختر اللغة',
    'appearance': 'المظهر',
    'select_theme': 'اختر المظهر',
    'theme_light': 'فاتح',
    'theme_dark': 'داكن',
    'theme_system': 'إعداد النظام',

    // Nearest Shop Page
    'nearest_shops_title': 'أقرب المتاجر',
    'detecting_location': 'جارٍ تحديد موقعك...',
    'finding_nearest_shops': 'جارٍ البحث عن أقرب متاجر شامسونج',
    'could_not_get_location': 'تعذّر تحديد موقعك',
    'enable_location_services':
        'تأكد من تفعيل خدمات الموقع ومنح الصلاحية اللازمة.',
    'try_again': 'حاول مجدداً',
    'no_shops_found_nearby': 'لا توجد متاجر قريبة',
    'no_shops_near_location':
        'لا توجد مراكز خدمة شامسونج بالقرب من موقعك الحالي.',
    'shops_found_near_you': 'متجر بالقرب منك',
    'shops_found_near_you_plural': 'متاجر بالقرب منك',
    'shop_open': 'مفتوح',
    'shop_closed': 'مغلق',
    'branch_unavailable': 'هذا الفرع غير متاح حالياً',
    'request_repair': 'طلب إصلاح',
    'shop_here': 'تسوق هنا',
    'distance_away_m': 'م',
    'distance_away_km': 'كم',

    // Consultation List Page
    'my_consultations': 'استشاراتي',
    'new_consultation_fab': 'جديد',
    'loading_consultations': 'جارٍ تحميل الاستشارات...',
    'no_consultations_yet': 'لا توجد استشارات بعد',
    'no_consultations_hint': 'اسأل الذكاء الاصطناعي أو فنياً\nعن مشكلة جهازك',
    'start_consultation': 'ابدأ استشارة',

    // Consultation Chat Page
    'new_consultation': 'استشارة جديدة',
    'ai_assistant': 'مساعد الذكاء الاصطناعي',
    'technician': 'الفني',
    'ask_question_below': 'اكتب سؤالك أدناه',
    'choose_type_hint':
        'اختر الذكاء الاصطناعي للإجابة الفورية\nأو الفني للمساعدة المتخصصة',
    'write_message_hint': 'اكتب رسالتك...',
    'awaiting_technician_reply':
        'في انتظار الرد من التقني\nشكراً لاستخدام هذه الخدمة 🙏',

    // Consultation Card
    'consultation_type_ai': 'ذكاء اصطناعي',
    'consultation_type_technician': 'فني',
    'consultation_status_answered': 'تمت الإجابة',
    'consultation_status_pending': 'قيد الانتظار',
    'awaiting_ai_response': 'في انتظار رد الذكاء الاصطناعي...',
    'awaiting_technician_response': 'في انتظار رد الفني...',
    'delete_consultation': 'حذف الاستشارة',
    'delete_consultation_confirm': 'هل أنت متأكد أنك تريد حذف هذه الاستشارة؟',

    // Consultation Type Selector
    'ask_ai': 'اسأل الذكاء الاصطناعي',
    'ask_technician': 'اسأل الفني',

    // Controller errors
    'enter_question_first': 'الرجاء إدخال سؤالك أولاً',
    'failed_to_send': '⚠ فشل الإرسال. حاول مجدداً.',
  };
}
