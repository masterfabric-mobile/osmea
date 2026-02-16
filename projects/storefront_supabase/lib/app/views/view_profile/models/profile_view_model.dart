import 'dart:async';
import 'package:core/core.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'module/states.dart';

@injectable
class ProfileViewModel extends BaseViewModelCubit<ProfileState> {
  final SupabaseClient _supabaseClient;
  late final StreamSubscription<AuthState> _authSubscription;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController usernameController;
  
  // New fields
  late final TextEditingController birthdateController; // Used for display
  DateTime? selectedBirthdate;
  String? selectedGender;
  
  // Address Fields (for editing single address - legacy)
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController postalCodeController;
  
  String? selectedCountry;
  String? selectedCity;

  // Multiple Addresses Management
  List<UserAddress> _userAddresses = [];
  List<UserAddress> get userAddresses => _userAddresses;
  
  // Address form controllers (for add/edit)
  late final TextEditingController addressLabelController;
  late final TextEditingController addressFormAddressController;
  late final TextEditingController addressFormPostalCodeController;
  late final TextEditingController addressFormPhoneController;
  String? addressFormSelectedCountry;
  String? addressFormSelectedCity;
  
  // Simple Data for Country/City Selection
  final Map<String, List<String>> countryCityMap = {
    'Türkiye': ['Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya'],
    'USA': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    'Germany': ['Berlin', 'Hamburg', 'Munich', 'Cologne', 'Frankfurt'],
    'France': ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice'],
    'United Kingdom': ['London', 'Birmingham', 'Manchester', 'Glasgow', 'Liverpool'],
  };
  
  List<String> get availableCities => selectedCountry != null 
      ? (countryCityMap[selectedCountry] ?? []) 
      : [];
  


  ProfileViewModel(this._supabaseClient) : super(ProfileInitial()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    usernameController = TextEditingController();
    birthdateController = TextEditingController();
    
    // Address
    phoneController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    
    // Multiple addresses form
    addressLabelController = TextEditingController();
    addressFormAddressController = TextEditingController();
    addressFormPostalCodeController = TextEditingController();
    addressFormPhoneController = TextEditingController();
    


    _authSubscription =
        _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchUserProfile(session.user.id);
      } else {
        stateChanger(const ProfileUnauthenticated());
      }
    });
  }

  Future<void> initial() async {
    stateChanger(ProfileLoading());
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser != null) {
      await _fetchUserProfile(currentUser.id);
    } else {
      stateChanger(const ProfileUnauthenticated());
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    bool justLoggedIn = false;
    if (state is ProfileUnauthenticated || (state is ProfileAuthenticated && !(state as ProfileAuthenticated).user.id.contains(userId))) {
      // If previous state was unauthenticated, or a different user was logged in,
      // it means a new login just occurred.
      justLoggedIn = true;
    }

    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      var user = AppUser.fromJson(response);

      // 30 gün içinde giriş yaptıysa silme planını iptal et (hesap tekrar açılmış sayılır)
      if (user.accountDeletionScheduledAt != null) {
        await _supabaseClient
            .from('users')
            .update({
              'account_deletion_scheduled_at': null,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('id', userId);
        user = AppUser(
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          username: user.username,
          createdAt: user.createdAt,
          avatarUrl: user.avatarUrl,
          role: user.role,
          gender: user.gender,
          age: user.age,
          birthdate: user.birthdate,
          phone: user.phone,
          address: user.address,
          city: user.city,
          postalCode: user.postalCode,
          country: user.country,
          accountDeletionScheduledAt: null,
        );
      }

      // Fetch order count for this user from Supabase orders table
      final orderRows = await _supabaseClient
          .from('orders')
          .select('id')
          .eq('user_id', userId);
      final orderCount = (orderRows as List).length;
      
      // Fetch address count for this user from Supabase user_addresses table
      final addressRows = await _supabaseClient
          .from('user_addresses')
          .select('id')
          .eq('user_id', userId);
      final addressCount = (addressRows as List).length;
      
      // Populate controllers immediately when data is fetched
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      
      selectedBirthdate = user.birthdate;
      if (selectedBirthdate != null) {
        birthdateController.text = DateFormat('yyyy-MM-dd').format(selectedBirthdate!);
      } else {
        birthdateController.clear();
      }
      
      selectedGender = user.gender;
      
      // Address
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
      postalCodeController.text = user.postalCode ?? '';
      selectedCountry = user.country;
      selectedCity = user.city;

      stateChanger(ProfileAuthenticated(
        user: user, 
        shouldRedirectToHome: justLoggedIn, 
        orderCount: orderCount,
        addressCount: addressCount,
      ));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(errorMessage: "Failed to load profile"));
    }
  }

  void resetRedirectFlag() {
    if (state is ProfileAuthenticated) {
      stateChanger((state as ProfileAuthenticated).copyWith(shouldRedirectToHome: false));
    }
  }

  void populateUserInfo() {
    if (state is ProfileAuthenticated) {
      final user = (state as ProfileAuthenticated).user;
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      
      selectedBirthdate = user.birthdate;
      if (selectedBirthdate != null) {
        birthdateController.text = DateFormat('yyyy-MM-dd').format(selectedBirthdate!);
      } else {
        birthdateController.clear();
      }
      
      selectedGender = user.gender;
      
      // Address
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
      postalCodeController.text = user.postalCode ?? '';
      selectedCountry = user.country;
      selectedCity = user.city;
    }
  }
  
  void setGender(String? gender) {
    selectedGender = gender;
    _refreshState();
  }
  
  void setCountry(String? country) {
    selectedCountry = country;
    selectedCity = null; // Reset city when country changes
    _refreshState();
  }
  
  void setCity(String? city) {
    selectedCity = city;
    _refreshState();
  }
  
  void _refreshState() {
     if (state is ProfileAuthenticated) {
       // Force state update by creating a new instance
       final currentState = state as ProfileAuthenticated;
       stateChanger(ProfileAuthenticated(
         user: currentState.user,
         shouldRedirectToHome: currentState.shouldRedirectToHome,
         orderCount: currentState.orderCount,
         addressCount: currentState.addressCount,
       ));
    }
  }

  Future<void> pickBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthdate ?? DateTime(2000), // Default to year 2000 if null
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedBirthdate) {
      selectedBirthdate = picked;
      birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      _refreshState();
    }
  }

  Future<void> updateAddress() async {
     if (state is! ProfileAuthenticated) return;
     final currentUser = (state as ProfileAuthenticated).user;
     stateChanger(ProfileLoading());
     
     try {
       final updates = {
         'phone': phoneController.text.trim(),
         'address': addressController.text.trim(),
         'city': selectedCity,
         'country': selectedCountry,
         'postal_code': postalCodeController.text.trim(),
         'updated_at': DateTime.now().toIso8601String(),
       };
       
       final response = await _supabaseClient
           .from('users')
           .update(updates)
           .eq('id', currentUser.id)
           .select()
           .single();
           
       final updatedUser = AppUser.fromJson(response);
       stateChanger((state as ProfileAuthenticated).copyWith(user: updatedUser));
     } catch (e) {
       stateChanger((state as ProfileAuthenticated).copyWith(user: currentUser)); 
       // Ideally handle error
     }
  }

  // Multiple Addresses Management Methods
  Future<void> loadUserAddresses() async {
    if (state is! ProfileAuthenticated) return;
    final currentState = state as ProfileAuthenticated;
    final userId = currentState.user.id;
    
    try {
      final response = await _supabaseClient
          .from('user_addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);
      
      _userAddresses = (response as List)
          .map((json) => UserAddress.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('loadUserAddresses: Loaded ${_userAddresses.length} addresses');
      
      // Update address count in state
      final addressCount = _userAddresses.length;
      
      // Force state update to trigger BlocBuilder rebuild
      // Create a new instance with copyWith - this ensures Cubit detects the change
      // Even though values are the same, new instance will trigger rebuild
      stateChanger(currentState.copyWith(
        user: currentState.user,
        shouldRedirectToHome: currentState.shouldRedirectToHome,
        orderCount: currentState.orderCount,
        addressCount: addressCount,
      ));
    } catch (e) {
      debugPrint('Error loading user addresses: $e');
    }
  }

  Future<bool> addAddress({
    String? label,
    required String address,
    required String city,
    String? postalCode,
    String? country,
    String? phone,
    bool setAsDefault = false,
  }) async {
    if (state is! ProfileAuthenticated) return false;
    final userId = (state as ProfileAuthenticated).user.id;
    
    try {
      final newAddress = {
        'user_id': userId,
        'label': label?.trim(),
        'address': address.trim(),
        'city': city.trim(),
        'postal_code': postalCode?.trim(),
        'country': country?.trim(),
        'phone': phone?.trim(),
        'is_default': setAsDefault,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      
      await _supabaseClient.from('user_addresses').insert(newAddress);
      await loadUserAddresses();
      // Update address count in state after adding
      if (state is ProfileAuthenticated) {
        final currentState = state as ProfileAuthenticated;
        stateChanger(currentState.copyWith(addressCount: _userAddresses.length));
      }
      return true;
    } catch (e) {
      debugPrint('Error adding address: $e');
      return false;
    }
  }

  Future<bool> updateUserAddress({
    required String addressId,
    String? label,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? phone,
    bool? setAsDefault,
  }) async {
    if (state is! ProfileAuthenticated) return false;
    
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      
      if (label != null) updates['label'] = label.trim();
      if (address != null) updates['address'] = address.trim();
      if (city != null) updates['city'] = city.trim();
      if (postalCode != null) updates['postal_code'] = postalCode.trim();
      if (country != null) updates['country'] = country.trim();
      if (phone != null) updates['phone'] = phone.trim();
      if (setAsDefault != null) updates['is_default'] = setAsDefault;
      
      await _supabaseClient
          .from('user_addresses')
          .update(updates)
          .eq('id', addressId);
      
      await loadUserAddresses();
      return true;
    } catch (e) {
      debugPrint('Error updating address: $e');
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    if (state is! ProfileAuthenticated) return false;
    
    try {
      await _supabaseClient
          .from('user_addresses')
          .delete()
          .eq('id', addressId);
      
      await loadUserAddresses();
      // Update address count in state after deleting
      if (state is ProfileAuthenticated) {
        final currentState = state as ProfileAuthenticated;
        stateChanger(currentState.copyWith(addressCount: _userAddresses.length));
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting address: $e');
      return false;
    }
  }

  Future<bool> setDefaultAddress(String addressId) async {
    if (state is! ProfileAuthenticated) return false;
    
    try {
      // The trigger will handle unsetting other defaults
      await _supabaseClient
          .from('user_addresses')
          .update({'is_default': true, 'updated_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', addressId);
      
      await loadUserAddresses();
      return true;
    } catch (e) {
      debugPrint('Error setting default address: $e');
      return false;
    }
  }

  void setAddressFormCountry(String? country) {
    addressFormSelectedCountry = country;
    addressFormSelectedCity = null; // Reset city when country changes
    _refreshState();
  }

  void setAddressFormCity(String? city) {
    addressFormSelectedCity = city;
    _refreshState();
  }

  void clearAddressForm() {
    addressLabelController.clear();
    addressFormAddressController.clear();
    addressFormPostalCodeController.clear();
    addressFormPhoneController.clear();
    addressFormSelectedCountry = null;
    addressFormSelectedCity = null;
  }

  void populateAddressForm(UserAddress address) {
    addressLabelController.text = address.label ?? '';
    addressFormAddressController.text = address.address ?? '';
    addressFormPostalCodeController.text = address.postalCode ?? '';
    addressFormPhoneController.text = address.phone ?? '';
    addressFormSelectedCountry = address.country;
    addressFormSelectedCity = address.city;
  }

  Future<void> updateProfile() async {
    if (state is! ProfileAuthenticated) return;
    
    final currentUser = (state as ProfileAuthenticated).user;
    final newUsername = usernameController.text.trim();
    
    // Calculate age from birthdate (Optional, if you still want to store age column)
    int? age;
    if (selectedBirthdate != null) {
      final now = DateTime.now();
      age = now.year - selectedBirthdate!.year;
      if (now.month < selectedBirthdate!.month || 
         (now.month == selectedBirthdate!.month && now.day < selectedBirthdate!.day)) {
        age--;
      }
    }

    stateChanger(ProfileLoading());

    try {
      // 1. Update public.users table
      final updates = {
        'username': newUsername,
        'birthdate': selectedBirthdate?.toIso8601String(), // Store as ISO string (or just 'yyyy-MM-dd')
        'age': age, // We update age based on birthdate
        'gender': selectedGender,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _supabaseClient
          .from('users')
          .update(updates)
          .eq('id', currentUser.id)
          .select()
          .single();

      final updatedUser = AppUser.fromJson(response);
      stateChanger((state as ProfileAuthenticated).copyWith(user: updatedUser));

    } catch (e) {
       stateChanger((state as ProfileAuthenticated).copyWith(user: currentUser)); 
    }
  }
  


  void switchToLogin() {
    _clearFieldsAndErrors();
    stateChanger(const ProfileUnauthenticated(showLoginView: true));
  }

  void switchToSignup() {
    _clearFieldsAndErrors();
    stateChanger(const ProfileUnauthenticated(showLoginView: false));
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'Please enter email and password.'));
      return;
    }
    stateChanger(ProfileLoading());
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user == null) {
        stateChanger(const ProfileUnauthenticated(
            errorMessage: 'Login failed. Please check your credentials.'));
      } else {
        _clearFieldsAndErrors();
        // The listener will handle the state change
      }
    } on AuthException catch (e) {
      stateChanger(ProfileUnauthenticated(errorMessage: e.message));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      stateChanger(
          const ProfileUnauthenticated(errorMessage: 'Please fill all fields.'));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      stateChanger(
          const ProfileUnauthenticated(errorMessage: 'Passwords do not match.'));
      return;
    }
    stateChanger(ProfileLoading());

    try {
      final response = await _supabaseClient.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {'username': usernameController.text.trim()},
      );
      if (response.user != null) {
        _clearFieldsAndErrors();
        stateChanger(const ProfileUnauthenticated(
            showLoginView: true,
            errorMessage:
                'Success! Please check your email to confirm your registration.'));
      } else {
        stateChanger(const ProfileUnauthenticated(
            errorMessage: 'Signup failed. Please try again.'));
      }
    } on AuthException catch (e) {
      stateChanger(ProfileUnauthenticated(errorMessage: e.message));
    } catch (e) {
      stateChanger(const ProfileUnauthenticated(
          errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> logout() async {
    stateChanger(ProfileLoading());
    await _supabaseClient.auth.signOut();
    _clearFieldsAndErrors();
  }

  /// Schedules the current user's account for deletion in 30 days.
  /// Sets account_deletion_scheduled_at in public.users, then signs out.
  /// Returns true on success, false on failure.
  Future<bool> scheduleAccountDeletion() async {
    if (state is! ProfileAuthenticated) return false;
    final currentUser = (state as ProfileAuthenticated).user;

    try {
      await _supabaseClient
          .from('users')
          .update({
            'account_deletion_scheduled_at': DateTime.now().toUtc().toIso8601String(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', currentUser.id);

      await _supabaseClient.auth.signOut();
      _clearFieldsAndErrors();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _clearFieldsAndErrors() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
    birthdateController.clear();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    birthdateController.dispose();
    phoneController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    addressLabelController.dispose();
    addressFormAddressController.dispose();
    addressFormPostalCodeController.dispose();
    addressFormPhoneController.dispose();
    return super.close();
  }
}