public with sharing class ExternalCredentialServiceImpl implements ExternalCredentialService.API {
    public ExternalCredentialService.IExternalCredentialCreateResponse createExternalCredential(ExternalCredentialService.ExternalCredentialCreateRequest request) {
        try {
            // Convert the request into raw metadata objects
            List<MetadataService.ExternalCredentialParameter> parameters = new List<MetadataService.ExternalCredentialParameter>();
            if (null != request.externalCredentialParameters) {
                for (ExternalCredentialService.ExternalCredentialParameter param : request.externalCredentialParameters) {
                    MetadataService.ExternalCredentialParameter mParam = new MetadataService.ExternalCredentialParameter();
                    mParam.authProvider = param.authProvider;
                    mParam.description = param.description;
                    mParam.parameterName = param.parameterName;
                    switch on param.parameterType {
                        when AuthHeader {
                            mParam.parameterType = 'AuthHeader';
                        }
                        when AuthParameter {
                            mParam.parameterType = 'AuthParameter';
                        }
                        when AuthProtocolVariant {
                            mParam.parameterType = 'AuthProtocolVariant';
                        }
                        when AuthProvider {
                            mParam.parameterType = 'AuthProvider';
                        }
                        when AuthProviderUrlQueryParameter {
                            mParam.parameterType = 'AuthProviderUrlQueryParameter';
                        }
                        when AwsStsPrincipal {
                            mParam.parameterType = 'AwsStsPrincipal';
                        }
                        when NamedPrincipal {
                            mParam.parameterType = 'NamedPrincipal';
                        }
                        when PerUserPrincipal {
                            mParam.parameterType = 'PerUserPrincipal';
                        }
                    }
                    mParam.parameterValue = param.parameterValue;
                    mParam.principal = param.principal;
                    mParam.sequenceNumber = param.sequenceNumber;
                    parameters.add(mParam);
                }
            }
            MetadataService.ExternalCredential mCred = new MetadataService.ExternalCredential();
            switch on request.authenticationProtocol {
                when AWSSV4 {
                    mCred.authenticationProtocol = 'AwsSv4';
                }
                when CUSTOM {
                    mCred.authenticationProtocol = 'Custrom';
                }
                when JWT {
                    mCred.authenticationProtocol = 'Jwt';
                }
                when JWTEXCHANGE {
                    mCred.authenticationProtocol = 'JwtExchange';
                }
                when NOAUTHENTICATION {
                    mCred.authenticationProtocol = 'NoAuthentication';
                }
                when OAUTH {
                    mCred.authenticationProtocol = 'Oauth';
                }
                when PASSWORD {
                    mCred.authenticationProtocol = 'Password';
                }
            }
            mCred.description = request.description;
            mCred.externalCredentialParameters = parameters;
            mCred.fullName = request.fullName;
            mCred.label = request.label;
            debugMetadataExternalCredential(mCred);
            List<MetadataService.SaveResult> saveResults = MetadataServiceWrapper.createMetadata(
                new List<MetadataService.Metadata> {
                    mCred
                }
            );
            if (null == saveResults || saveResults.isEmpty()) {
                return new ExternalCredentialCreateResponse(false, 'No save results');
            }
            MetadataService.SaveResult saveResult = saveResults.get(0);
            if (saveResult.success) {
                return new ExternalCredentialCreateResponse(true, null);
            } else {
                String message = '';
                for (MetadataService.Error error : saveResult.errors) {
                    message = message + error.message;
                }
                return new ExternalCredentialCreateResponse(false, message);
            }
        } catch (Exception e) {
            return new ExternalCredentialCreateResponse(false, e.getMessage());
        }
    }

    private class ExternalCredentialCreateResponse implements ExternalCredentialService.IExternalCredentialCreateResponse {
        Boolean ok;
        String message;
        
        public ExternalCredentialCreateResponse(
            Boolean ok,
            String message
        ) {
            this.ok = ok;
            this.message = message;
        }

        public Boolean isOk() {
            return ok;
        }

        public String getMessage() {
            return message;
        }
    }

    public void debugMetadataExternalCredential(MetadataService.ExternalCredential credential) {
        System.debug('Credential');
        System.debug('fullName:' + credential.fullName);
        System.debug('authenticationProtocol:' + credential.authenticationProtocol);
        System.debug('description:' + credential.description);
        System.debug('label:' + credential.label);
        for (MetadataService.ExternalCredentialParameter param : credential.externalCredentialParameters) {
            System.debug('Parameter');
            System.debug('authProvider:' + param.authProvider);
            System.debug('description:' + param.description);
            System.debug('parameterName:' + param.parameterName);
            System.debug('parameterType:' + param.parameterType);
            System.debug('parameterValue:' + param.parameterValue);
            System.debug('principal:' + param.principal);
            System.debug('sequenceNumber:' + param.sequenceNumber);
        }
    }
}