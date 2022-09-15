public with sharing class MetadataTest {

    public static void listExternalCredentials() {
        List<MetadataService.FileProperties> props = MetadataServiceWrapper.listMetadata('ExternalCredential');
        for (MetadataService.FileProperties prop: props) {
            System.debug(prop.fullName);
        }
    }

    public static List<MetadataService.ExternalCredential> readCredentials(List<String> names) {
        MetadataService.IReadResult res = MetadataServiceWrapper.readMetadata('ExternalCredential', names);
        List<MetadataService.ExternalCredential> credentials = (List<MetadataService.ExternalCredential>) res.getRecords();
        for (MetadataService.ExternalCredential credential: credentials) {
            ExternalCredentialService.debugMetadataExternalCredential(credential);
        }
        return credentials;
    }

    public static void upsertCredentials(List<MetadataService.ExternalCredential> credentials) {
        List<MetadataService.UpsertResult> results = MetadataServiceWrapper.upsertMetadata(credentials);
        for (MetadataService.UpsertResult result: results) {
            if (result.success) {
                System.debug('Success');
            } else {
                String message = '';
                for (MetadataService.Error error : result.errors) {
                    message = message + error.message;
                }
                System.debug('Failed:' + message);
            }
        }
    }

    public static void createExternalCredential() {
        ExternalCredentialService.IExternalCredentialCreateResponse result = ExternalCredentialService.createExternalCredential(
            ExternalCredentialService.externalCredentialCreateRequestBuilder()
                .fullName('Metadata_External_Credential')
                .authenticationProtocol(ExternalCredentialService.AuthenticationProtocol.OAUTH)
                .externalCredentialParameters(
                    new List<ExternalCredentialService.ExternalCredentialParameter> {
                        ExternalCredentialService.externalCredentialParameterBuilder()
                        .authProvider('Atlassian')
                        .parameterName('AuthProvider')
                        .parameterType(ExternalCredentialService.ParameterType.AuthProvider)
                        .build()
                    }
                )
                .label('Metadata')
                .build()
        );
        if (result.isOk()) {
            System.debug('Created external credential');
        } else {
            System.debug('Failed to create external credential: ' + result.getMessage());
        }
    }
}