public with sharing class AuthProviderServiceImpl implements AuthProviderService.API {
    
	@TestVisible
	private static final String AUTH_PROVIDER_METADATA_TYPE = 'AuthProvider';
    
    public AuthProviderServiceImpl() {
    }

    public AuthProviderService.GetAuthProviderResponse getAuthProvider(AuthProviderService.GetAuthProviderRequest req) {
        try {
            MetadataService.IReadResult result = MetadataServiceWrapper.readMetadata(
                AUTH_PROVIDER_METADATA_TYPE,
                new List<String>{ req.getFullName() }
            );
            MetadataService.Metadata[] records = result.getRecords();
            if (null != records && !records.isEmpty()) {
                MetadataService.Metadata record = records.get(0);
                if (record instanceof MetadataService.AuthProvider) {
                    MetadataService.AuthProvider ap = (MetadataService.AuthProvider) record;
                    
                    System.debug(ap.authorizeUrl);
                    System.debug(ap.consumerKey);
                    System.debug(ap.consumerSecret);
                    System.debug(ap.customMetadataTypeRecord);
                    System.debug(ap.defaultScopes);
                    System.debug(ap.errorUrl);
                    System.debug(ap.executionUser);
                    System.debug(ap.friendlyName);
                    System.debug(ap.fullName);
                    System.debug(ap.iconUrl);
                    System.debug(ap.idTokenIssuer);
                    System.debug(ap.includeOrgIdInIdentifier);
                    System.debug(ap.linkKickoffUrl);
                    System.debug(ap.logoutUrl);
                    System.debug(ap.oauthKickoffUrl);
                    System.debug(ap.plugin);
                    System.debug(ap.providerType);
                    System.debug(ap.sendAccessTokenInHeader);
                    System.debug(ap.sendClientCredentialsInHeader);
                    System.debug(ap.sendSecretInApis);
                    System.debug(ap.tokenUrl);
                    System.debug(ap.ssoKickoffUrl);
                    System.debug(ap.userInfoUrl);
                    return new AuthProviderService.GetAuthProviderResponse(
                        true, null, null
                    )
                    .authorizeUrl(ap.authorizeUrl)
                    .consumerKey(ap.consumerKey)
                    .consumerSecret(ap.consumerSecret)
                    .defaultScopes(ap.defaultScopes)
                    .friendlyName(ap.friendlyName)
                    .fullName(ap.fullName)
                    .includeOrgIdInIdentifier(ap.includeOrgIdInIdentifier)
                    .providerType(ap.providerType)
                    .sendAccessTokenInHeader(ap.sendAccessTokenInHeader)
                    .sendClientCredentialsInHeader(ap.sendClientCredentialsInHeader)
                    .sendSecretInApis(ap.sendSecretInApis)
                    .tokenUrl(ap.tokenUrl);
                } else {
                    return new AuthProviderService.GetAuthProviderResponse(
                        false, null, 'Returned record not of the expected type'
                    );
                }
            } else {
                return new AuthProviderService.GetAuthProviderResponse(
                    true, 'No records found', null
                );
            }
        } catch (Exception e) {
            return new AuthProviderService.GetAuthProviderResponse(
                false, null, e.getMessage()
            );
        }
    }

    public AuthProviderService.CreateAuthProviderResponse createUpdateAuthProvider(AuthProviderService.CreateUpdateAuthProviderRequest req) {
        try {
            // If there is an existing Auth Provider then we need to check if update is allowed
            AuthProviderService.GetAuthProviderRequest checkReq = new AuthProviderService.GetAuthProviderRequest()
                .fullName(req.getFullName());
            AuthProviderService.GetAuthProviderResponse checkResp = getAuthProvider(checkReq);
            if (!checkResp.isOk()) {
                return new AuthProviderService.CreateAuthProviderResponse(
                    false, null, 'Could not check for existing Auth. Provider:' + checkResp.getError()
                );
            }
            if (checkResp.getFullName() != null && ! req.getAllowUpdate()) {
                return new AuthProviderService.CreateAuthProviderResponse(
                    false, null, 'Existing Auth. Provider with the same fullname found and allow update is false'
                );
            }
            MetadataService.AuthProvider auth = new MetadataService.AuthProvider();
            auth.authorizeUrl = req.getAuthorizeUrl();
            auth.consumerKey = req.getConsumerKey();
            auth.consumerSecret = req.getConsumerSecret();
            auth.defaultScopes = req.getDefaultScopes();
            auth.friendlyName = req.getFriendlyName();
            auth.fullName = req.getFullName();
            auth.includeOrgIdInIdentifier = req.getIncludeOrgIdInIdentifier();
            auth.providerType = req.getProviderType();
            auth.sendAccessTokenInHeader = req.getSendAccessTokenInHeader();
            auth.sendClientCredentialsInHeader = req.getSendClientCredentialsInHeader();
            auth.sendSecretInApis = req.getSendSecretInApis();
            auth.tokenUrl = req.getTokenUrl();
            auth.executionUser = UserInfo.getUserName();
            auth.plugin = 'Test';
            auth.plugin = null;
            System.debug(auth);

            List<MetadataService.UpsertResult> results = MetadataServiceWrapper.upsertMetadata(
                new List<MetadataService.Metadata>{ auth }
            );
            if (null == results || results.isEmpty()) {
                // This should never happen but better safe than sorry
                return new AuthProviderService.CreateAuthProviderResponse(
                    false, null, 'No Upsert Results'
                ); 
            }
            MetadataService.UpsertResult result = results.get(0);
            if (!result.success) {
                String errorMessage = 'Failed to update or create Auth. Provider: ';
                if (null != result.errors && !result.errors.isEmpty()) {
                    for (MetadataService.Error error: result.errors) {
                        errorMessage = errorMessage + error.message;
                    }
                }
                
                return new AuthProviderService.CreateAuthProviderResponse(
                    false, null, errorMessage
                );
            }
            return new AuthProviderService.CreateAuthProviderResponse(
                true, null, null
            );
        } catch (Exception e) {
            return new AuthProviderService.CreateAuthProviderResponse(
                false, null, e.getMessage()
            );
        }
    }
}