/*
 * Copyright (c) 2022 FinancialForce.com, inc. All rights reserved.
 */
/**
 * Service wrapper around ExternalCredentials using the Metadata API.
 */
 public with sharing class ExternalCredentialService {
    private static final Dependency implementation = new Dependency(
        'ExternalCredentialServiceImpl'
    );

    public interface API {
        IExternalCredentialCreateResponse createExternalCredential(ExternalCredentialCreateRequest request);
        void debugMetadataExternalCredential(MetadataService.ExternalCredential credential);
    }

    /**
     * Create an external credential via the Metadata API.
     * @param request A ExternalCredentialCreateRequest specifying the external credential to create.
     * @return An IExternalCredentialCreateResponse specifying the result.
     * @see externalCredentialParameterBuilder()
     */
    public static IExternalCredentialCreateResponse createExternalCredential(ExternalCredentialCreateRequest request) {
        return service().createExternalCredential(request);
    }

    public static void debugMetadataExternalCredential(MetadataService.ExternalCredential credential) {
        service().debugMetadataExternalCredential(credential);
    }

    @TestVisible
    private ExternalCredentialService() {} 

    private static API service() {
        return (API) implementation.newInstance();
    }

    public interface IExternalCredentialCreateResponse {
        Boolean isOk();
        String getMessage();
    }

    /**
     * Valid values for ExternalCredentialParameter.parameterType.
     */
    public enum ParameterType {
        AuthHeader,
        AuthParameter,
        AuthProtocolVariant,
        AuthProvider,
        AuthProviderUrlQueryParameter,
        AwsStsPrincipal,
        NamedPrincipal,
        PerUserPrincipal
    }

    /**
     * Object wrapper around Metadata ExternalCredentialParameter
     * Can only be constructed using the builder class
     * @see externalCredentialParameterBuilder()
     */
    public class ExternalCredentialParameter {
        /**
         * The developer name of the authProvider if parameterType is AuthProvider.
         * Required if parameterType is AuthProvider.
         */
        public String authProvider {get; private set;}
        /**
         * A description for the External Credential Parameter.
         * Optional.
         */
        public String description {get; private set;}
        /**
         * A name for this parameter.
         * Required.
         */
        public String parameterName {get; private set;}
        /**
         * The type of the parameter.
         * Required.
         */
        public ParameterType parameterType {get; private set;}
        /**
         * The value for the parameter for the types that do not have specific fields.
         * Optional.
         */
        public String parameterValue {get; private set;}
        /**
         * The permission set to use if parameterType is NamedPrincipal or PerUserPrincipal.
         * Required if parameterType is NamedPrincipal or PerUserPrincipal.
         */
        public String principal {get; private set;}
        /**
         * The sequence number controlling the application of parameters where applicable.
         * Optional.
         */
        public Integer sequenceNumber {get; private set;}

        private ExternalCredentialParameter(
            String authProvider,
            String description,
            String parameterName,
            ParameterType parameterType,
            String parameterValue,
            String principal,
            Integer sequenceNumber
        ) {
            this.authProvider = authProvider;
            this.description = description;
            this.parameterName = parameterName;
            this.parameterType = parameterType;
            this.parameterValue = parameterValue;
            this.principal = principal;
            this.sequenceNumber = sequenceNumber;
        }
    }

    /**
     * Get a builder for ExternalCredentialParameter.
     * @return A builder for ExternalCredentialParameter.
     */
    public static ExternalCredentialParameterBuilder externalCredentialParameterBuilder() {
        return new ExternalCredentialParameterBuilder();
    }

    /**
     * Builder for ExternalCredentialParameter.
     */
    public class ExternalCredentialParameterBuilder {
        private String authProvider;
        private String description;
        private String parameterName;
        private ParameterType parameterType;
        private String parameterValue;
        private String principal;
        private Integer sequenceNumber;

        private ExternalCredentialParameterBuilder() {}

        /**
         * Validate parameters set via the fluent methods and construct a ExternalCredentialParameter instance.
         * @return ExternalCredentialParameter instance.
         * @throws IllegalArgumentException when an invalid set of parameters are set.
         */
        public ExternalCredentialParameter build() {
            if (null == parameterName) {
                throw new IllegalArgumentException('parameterName must not be null');
            }
            if (null == parameterType) {
                throw new IllegalArgumentException('parameterType must not be null');
            }
            if (parameterType == ExternalCredentialService.ParameterType.AuthProvider && null == authProvider) {
                throw new IllegalArgumentException('authProvider must be non-null when paramterType is AuthProvider');
            }
            return new ExternalCredentialParameter(
                authProvider,
                description,
                parameterName,
                parameterType,
                parameterValue,
                principal,
                sequenceNumber
            );
        }

        /**
         * The developer name of the authProvider if parameterType is AuthProvider.
         * Required if parameterType is AuthProvider.
         */
        public ExternalCredentialParameterBuilder authProvider(String authProvider) {
            this.authProvider = authProvider;
            return this;
        }

        /**
         * A description for the External Credential Parameter.
         * Optional.
         */
        public ExternalCredentialParameterBuilder description(String description) {
            this.description = description;
            return this;
        }

        /**
         * A name for this parameter.
         * Required.
         */
        public ExternalCredentialParameterBuilder parameterName(String parameterName) {
            this.parameterName = parameterName;
            return this;
        }

        /**
         * The type of the parameter.
         * Required.
         */
        public ExternalCredentialParameterBuilder parameterType(ParameterType parameterType) {
            this.parameterType = parameterType;
            return this;
        }

        /**
         * The value for the parameter for the types that do not have specific fields.
         * Optional.
         */
        public ExternalCredentialParameterBuilder parameterValue(String parameterValue) {
            this.parameterValue = parameterValue;
            return this;
        }

        /**
         * The permission set to use if parameterType is NamedPrincipal or PerUserPrincipal.
         * Required if parameterType is NamedPrincipal or PerUserPrincipal.
         */
        public ExternalCredentialParameterBuilder principal(String principal) {
            this.principal = principal;
            return this;
        }

        /**
         * The sequence number controlling the application of parameters where applicable.
         * Optional.
         */
        public ExternalCredentialParameterBuilder sequenceNumber(Integer sequenceNumber) {
            this.sequenceNumber = sequenceNumber;
            return this;
        }
    }

    /**
     * Valid values for ExternalCredential.authenticationProtocol
     */
    public enum AuthenticationProtocol {
        AWSSV4,
        CUSTOM,
        JWT,
        JWTEXCHANGE,
        NOAUTHENTICATION,
        OAUTH,
        PASSWORD
    }

    /**
     * A request to create an External Credential.
     */
    public class ExternalCredentialCreateRequest {
        public String fullName {get; private set;}
        public AuthenticationProtocol authenticationProtocol {get; private set;}
        public String description {get; private set;}
        public List<ExternalCredentialParameter> externalCredentialParameters {get; private set;}
        public String label {get; private set;}

        private ExternalCredentialCreateRequest(
            String fullName,
            AuthenticationProtocol authenticationProtocol,
            String description,
            List<ExternalCredentialParameter> externalCredentialParameters,
            String label
        ) {
            this.fullName = fullName;
            this.authenticationProtocol = authenticationProtocol;
            this.description = description;
            this.externalCredentialParameters = externalCredentialParameters;
            this.label = label;
        }
    }
    /**
     * Get a builder for ExternalCredentialCreateRequest.
     * @return A builder for ExternalCredentialCreateRequest.
     */
    public static ExternalCredentialCreateRequestBuilder externalCredentialCreateRequestBuilder() {
        return new ExternalCredentialCreateRequestBuilder();
    }

    public class ExternalCredentialCreateRequestBuilder {
        private String fullName; // required
        private AuthenticationProtocol authenticationProtocol; //required
        private String description;
        private List<ExternalCredentialParameter> externalCredentialParameters;
        private String label;

        private ExternalCredentialCreateRequestBuilder() {}

        public ExternalCredentialCreateRequest build() {
            if (null == fullName || fullName.length() == 0) {
                throw new IllegalArgumentException('fullName must be non-null and non zero length');
            }
            if (null == authenticationProtocol) {
                throw new IllegalArgumentException('authenticationProtocol must be non-null');
            }
            return new ExternalCredentialCreateRequest(
                fullName,
                authenticationProtocol,
                description,
                externalCredentialParameters,
                label
            );
        }

        public ExternalCredentialCreateRequestBuilder fullName(String fullName) {
            this.fullName = fullName;
            return this;
        }

        public ExternalCredentialCreateRequestBuilder authenticationProtocol(AuthenticationProtocol authenticationProtocol) {
            this.authenticationProtocol = authenticationProtocol;
            return this;
        }

        public ExternalCredentialCreateRequestBuilder description(String description) {
            this.description = description;
            return this;
        }

        public ExternalCredentialCreateRequestBuilder externalCredentialParameters(List<ExternalCredentialParameter> externalCredentialParameters) {
            this.externalCredentialParameters = externalCredentialParameters;
            return this;
        }

        public ExternalCredentialCreateRequestBuilder label(String label) {
            this.label = label;
            return this;
        }
    }
}