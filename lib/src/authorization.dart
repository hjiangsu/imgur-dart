part of './imgur.dart';

/// Authorization information for a given Imgur instance.
class Authorization {
  late Imgur _imgur;
  late String? _callbackURL;

  Map<String, dynamic> authorizationInformation = {};

  Authorization._create({required Imgur imgur, String? callbackURL}) {
    _imgur = imgur;
    _callbackURL = callbackURL;
  }

  /// Factory function to generate the Authorization instance
  static Future<Authorization> create({required Imgur imgur, String? callbackURL}) async {
    Authorization authorizationInstance = Authorization._create(imgur: imgur, callbackURL: callbackURL);

    // Do initialization that requires async
    await authorizationInstance._initialize(clientId: imgur.clientId, clientSecret: ""); // Empty client secret for now

    // Return the fully initialized object
    return authorizationInstance;
  }

  /// Initialization function for Authorization class
  _initialize({required String clientId, required String clientSecret}) async {}

  /// Performs user re-authorization with a given refresh token. A callback URL must be specified in the creation of the authorization instance.
  /// The callback must provide a JSON response with the associated information.
  refreshUserAuthorization({required String refreshToken}) async {
    if (_callbackURL == null) {
      throw Exception("Missing callback URL to refresh user token");
    }

    final Response response = await dio.post(
      _callbackURL!,
      data: {
        "refresh_token": refreshToken,
      },
    );

    authorizationInformation = response.data;
  }

  /// Performs re-authorization for the client and/or user. If refreshCredentials is provided, it will attempt to refresh the access token for the given user.
  ///
  /// The refreshCredential parameter should contain the following keys: access_token, refresh_token.
  /// If any of those keys are missing, then an error will be thrown.
  reauthorize({Map<String, dynamic>? refreshCredentials}) async {
    if (refreshCredentials != null) {
      // Re-authorize with a given user who has previously been authorized
      if (!refreshCredentials.containsKey("access_token") || !refreshCredentials.containsKey("refresh_token")) {
        throw Exception('Re-authorization failed because refreshCredentials keys were not properly provided');
      }

      final refreshToken = refreshCredentials["refresh_token"];
      await refreshUserAuthorization(refreshToken: refreshToken);
    } else {
      // Re-authorize with normal client id and secret
      await _initialize(clientId: _imgur.clientId, clientSecret: ""); // Empty client secret for now
    }
  }

  /// Sets the authorization information manually from a given auth parameter.
  setAuthorization(Map<String, dynamic> auth) {
    authorizationInformation = auth;
  }

  String? get accessToken => authorizationInformation["access_token"];
  bool get isInitialized => authorizationInformation.isNotEmpty;
  bool get isUserAuthenticated => authorizationInformation.containsKey("refresh_token");
}
