// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log In`
  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account ? Sign Up`
  String get registerMessage {
    return Intl.message(
      'Don\'t have an account ? Sign Up',
      name: 'registerMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue as a guest`
  String get guestMessage {
    return Intl.message(
      'Continue as a guest',
      name: 'guestMessage',
      desc: '',
      args: [],
    );
  }

  /// `Device is not connected to the internet`
  String get connectionMessage {
    return Intl.message(
      'Device is not connected to the internet',
      name: 'connectionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for joining us!`
  String get thankYou {
    return Intl.message(
      'Thanks for joining us!',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message(
      'Hi',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Repeat your Password`
  String get repeatPassword {
    return Intl.message(
      'Repeat your Password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message(
      'Log Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `ChatBot`
  String get chatbot {
    return Intl.message(
      'ChatBot',
      name: 'chatbot',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `You need to Log in to use the chat bot`
  String get guestChatMessage {
    return Intl.message(
      'You need to Log in to use the chat bot',
      name: 'guestChatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Take an Image`
  String get takeImage {
    return Intl.message(
      'Take an Image',
      name: 'takeImage',
      desc: '',
      args: [],
    );
  }

  /// `Pick Image`
  String get pickImage {
    return Intl.message(
      'Pick Image',
      name: 'pickImage',
      desc: '',
      args: [],
    );
  }

  /// `take or pick an image first`
  String get TPImageFirst {
    return Intl.message(
      'take or pick an image first',
      name: 'TPImageFirst',
      desc: '',
      args: [],
    );
  }

  /// `Detect Diseases`
  String get detectDiseases {
    return Intl.message(
      'Detect Diseases',
      name: 'detectDiseases',
      desc: '',
      args: [],
    );
  }

  /// `No leaves detected in the given image try uploading another  image`
  String get noleaves {
    return Intl.message(
      'No leaves detected in the given image try uploading another  image',
      name: 'noleaves',
      desc: '',
      args: [],
    );
  }

  /// `Detecting disease...`
  String get detecting {
    return Intl.message(
      'Detecting disease...',
      name: 'detecting',
      desc: '',
      args: [],
    );
  }

  /// `Healthy`
  String get healthy {
    return Intl.message(
      'Healthy',
      name: 'healthy',
      desc: '',
      args: [],
    );
  }

  /// `Description:`
  String get description {
    return Intl.message(
      'Description:',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `no Diseases detected in your plant`
  String get noDetection {
    return Intl.message(
      'no Diseases detected in your plant',
      name: 'noDetection',
      desc: '',
      args: [],
    );
  }

  /// `Cause:`
  String get cause {
    return Intl.message(
      'Cause:',
      name: 'cause',
      desc: '',
      args: [],
    );
  }

  /// `Organic Treatment:`
  String get organicTreatment {
    return Intl.message(
      'Organic Treatment:',
      name: 'organicTreatment',
      desc: '',
      args: [],
    );
  }

  /// `Chemical Treatment:`
  String get chemicalTreatment {
    return Intl.message(
      'Chemical Treatment:',
      name: 'chemicalTreatment',
      desc: '',
      args: [],
    );
  }

  /// `Login to view`
  String get loginToView {
    return Intl.message(
      'Login to view',
      name: 'loginToView',
      desc: '',
      args: [],
    );
  }

  /// `AI Chat`
  String get AIChat {
    return Intl.message(
      'AI Chat',
      name: 'AIChat',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, I was unable to provide a response. Please try again.`
  String get noResponse {
    return Intl.message(
      'Sorry, I was unable to provide a response. Please try again.',
      name: 'noResponse',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
