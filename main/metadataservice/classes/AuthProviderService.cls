/*
 * Copyright (c) 2022 FinancialForce.com, inc. All rights reserved.
 */
/**
 * Abstraction layer for handling Auth Provider.
 * Note that creating an OpenIdConnect Auth. Provider failes claiming it needs an Execution User when is not required at all. Pushing metadata works...
 */
public with sharing class AuthProviderService {
    @TestVisible
    private static final Dependency implementation = new Dependency(
        'AuthProviderServiceImpl'
    );

    public interface API {
        GetAuthProviderResponse getAuthProvider(GetAuthProviderRequest req);
        CreateAuthProviderResponse createUpdateAuthProvider(CreateUpdateAuthProviderRequest req);
    }

    public static GetAuthProviderResponse getAuthProvider(GetAuthProviderRequest req) {
        return service().getAuthProvider(req);
    }

    public static CreateAuthProviderResponse createUpdateAuthProvider(CreateUpdateAuthProviderRequest req) {
        return service().createUpdateAuthProvider(req);
    }

    private static API service() {
        return (API) implementation.newInstance();
    }

    @TestVisible
    private AuthProviderService() {
    }

    public class CreateAuthProviderResponse extends ServiceResponse {
        public CreateAuthProviderResponse(
            Boolean isOk,
            String warning,
            String error
        ) {
            super(
                isOk,
                warning,
                error
            );
        }
    }
    public class CreateUpdateAuthProviderRequest {
        private Boolean allowUpdate;
        private String authorizeUrl;
        private String consumerKey;
        private String consumerSecret;
        private String defaultScopes;
        private String friendlyName;
        private String fullName;
        private Boolean includeOrgIdInIdentifier;
        private String providerType;
        private Boolean sendAccessTokenInHeader;
        private Boolean sendClientCredentialsInHeader;
        private Boolean sendSecretInApis;
        private String tokenUrl;

        public CreateUpdateAuthProviderRequest() {}

        public CreateUpdateAuthProviderRequest allowUpdate(Boolean allowUpdate) {
            this.allowUpdate = allowUpdate;
            return this;
        }

        public CreateUpdateAuthProviderRequest authorizeUrl(String authorizeUrl) {
            this.authorizeUrl = authorizeUrl;
            return this;
        }

        public CreateUpdateAuthProviderRequest consumerKey(String consumerKey) {
            this.consumerKey = consumerKey;
            return this;
        }

        public CreateUpdateAuthProviderRequest consumerSecret(String consumerSecret) {
            this.consumerSecret = consumerSecret;
            return this;
        }

        public CreateUpdateAuthProviderRequest defaultScopes(String defaultScopes) {
            this.defaultScopes = defaultScopes;
            return this;
        }

        public CreateUpdateAuthProviderRequest friendlyName(String friendlyName) {
            this.friendlyName = friendlyName;
            return this;
        }

        public CreateUpdateAuthProviderRequest fullName(String fullName) {
            this.fullName = fullName;
            return this;
        }

        public CreateUpdateAuthProviderRequest includeOrgIdInIdentifier(Boolean includeOrgIdInIdentifier) {
            this.includeOrgIdInIdentifier = includeOrgIdInIdentifier;
            return this;
        }

        public CreateUpdateAuthProviderRequest providerType(String providerType) {
            this.providerType = providerType;
            return this;
        }

        public CreateUpdateAuthProviderRequest sendAccessTokenInHeader(Boolean sendAccessTokenInHeader) {
            this.sendAccessTokenInHeader = sendAccessTokenInHeader;
            return this;
        }

        public CreateUpdateAuthProviderRequest sendClientCredentialsInHeader(Boolean sendClientCredentialsInHeader) {
            this.sendClientCredentialsInHeader = sendClientCredentialsInHeader;
            return this;
        }

        public CreateUpdateAuthProviderRequest sendSecretInApis(Boolean sendSecretInApis) {
            this.sendSecretInApis = sendSecretInApis;
            return this;
        }

        public CreateUpdateAuthProviderRequest tokenUrl(String tokenUrl) {
            this.tokenUrl = tokenUrl;
            return this;
        }

        public Boolean getAllowUpdate() {
            return allowUpdate;
        }

        public String getAuthorizeUrl() {
            return authorizeUrl;
        }

        public String getConsumerKey() {
            return consumerKey;
        }

        public String getConsumerSecret() {
            return consumerSecret;
        }

        public String getDefaultScopes() {
            return defaultScopes;
        }

        public String getFriendlyName() {
            return friendlyName;
        }

        public String getFullName() {
            return fullName;
        }

        public Boolean getIncludeOrgIdInIdentifier() {
            return includeOrgIdInIdentifier;
        }

        public String getProviderType() {
            return providerType;
        }

        public Boolean getSendAccessTokenInHeader() {
            return sendAccessTokenInHeader;
        }

        public Boolean getSendClientCredentialsInHeader() {
            return sendClientCredentialsInHeader;
        }

        public Boolean getSendSecretInApis() {
            return sendSecretInApis;
        }

        public String getTokenUrl() {
            return tokenUrl;
        }
    }
    public class GetAuthProviderResponse extends ServiceResponse {
        private String authorizeUrl;
        private String consumerKey;
        private String consumerSecret;
        private String defaultScopes;
        private String friendlyName;
        private String fullName;
        private Boolean includeOrgIdInIdentifier;
        private String providerType;
        private Boolean sendAccessTokenInHeader;
        private Boolean sendClientCredentialsInHeader;
        private Boolean sendSecretInApis;
        private String tokenUrl;
        
        public GetAuthProviderResponse(
            Boolean isOk,
            String warning,
            String error
        ) {
            super(
                isOk,
                warning,
                error
            );
        }

        public GetAuthProviderResponse authorizeUrl(String authorizeUrl) {
            this.authorizeUrl = authorizeUrl;
            return this;
        }

        public GetAuthProviderResponse consumerKey(String consumerKey) {
            this.consumerKey = consumerKey;
            return this;
        }

        public GetAuthProviderResponse consumerSecret(String consumerSecret) {
            this.consumerSecret = consumerSecret;
            return this;
        }

        public GetAuthProviderResponse defaultScopes(String defaultScopes) {
            this.defaultScopes = defaultScopes;
            return this;
        }

        public GetAuthProviderResponse friendlyName(String friendlyName) {
            this.friendlyName = friendlyName;
            return this;
        }

        public GetAuthProviderResponse fullName(String fullName) {
            this.fullName = fullName;
            return this;
        }

        public GetAuthProviderResponse includeOrgIdInIdentifier(Boolean includeOrgIdInIdentifier) {
            this.includeOrgIdInIdentifier = includeOrgIdInIdentifier;
            return this;
        }

        public GetAuthProviderResponse providerType(String providerType) {
            this.providerType = providerType;
            return this;
        }

        public GetAuthProviderResponse sendAccessTokenInHeader(Boolean sendAccessTokenInHeader) {
            this.sendAccessTokenInHeader = sendAccessTokenInHeader;
            return this;
        }

        public GetAuthProviderResponse sendClientCredentialsInHeader(Boolean sendClientCredentialsInHeader) {
            this.sendClientCredentialsInHeader = sendClientCredentialsInHeader;
            return this;
        }

        public GetAuthProviderResponse sendSecretInApis(Boolean sendSecretInApis) {
            this.sendSecretInApis = sendSecretInApis;
            return this;
        }

        public GetAuthProviderResponse tokenUrl(String tokenUrl) {
            this.tokenUrl = tokenUrl;
            return this;
        }

        public String getAuthorizeUrl() {
            return authorizeUrl;
        }

        public String getConsumerKey() {
            return consumerKey;
        }

        public String getConsumerSecret() {
            return consumerSecret;
        }

        public String getDefaultScopes() {
            return defaultScopes;
        }

        public String getFriendlyName() {
            return friendlyName;
        }

        public String getFullName() {
            return fullName;
        }

        public Boolean getIncludeOrgIdInIdentifier() {
            return includeOrgIdInIdentifier;
        }

        public String getProviderType() {
            return providerType;
        }

        public Boolean getSendAccessTokenInHeader() {
            return sendAccessTokenInHeader;
        }

        public Boolean getSendClientCredentialsInHeader() {
            return sendClientCredentialsInHeader;
        }

        public Boolean getSendSecretInApis() {
            return sendSecretInApis;
        }

        public String getTokenUrl() {
            return tokenUrl;
        }
    }
    public class GetAuthProviderRequest {
        private String fullName;

        public GetAuthProviderRequest() {
        }

        public GetAuthProviderRequest fullName(String fullName) {
            this.fullName = fullName;
            return this;
        }

        public String getFullName() {
            return fullName;
        }
    }
}