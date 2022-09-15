public with sharing class DemoSetup {
    public static void createAuthProvider() {
        AuthProviderService.CreateUpdateAuthProviderRequest req = new AuthProviderService.CreateUpdateAuthProviderRequest()
        .allowUpdate(true)
        .authorizeUrl('https://auth.atlassian.com/authorize?audience=api.atlassian.com')
        .consumerKey('zfnXHc8TgqBFmS3qQjolD23EyTzEHe4V')
        .consumerSecret('8riCXuX92SRWqOnwgPPH+aKvuh/FYmUf8sW0yTQ752T6hf+2UFEG8wfsgjW4kJF6wxyWsp18e70uG6hoKbvcy3BBGPdiC2rX')
        //.defaultScopes('read:jira-work,manage:jira-project,manage:jira-configuration,read:jira-user,write:jira-work,manage:jira-data-provide,offline_access')
        .friendlyName('Demo Provider')
        .fullName('demo_provider')
        .includeOrgIdInIdentifier(false)
        .providerType('OpenIdConnect')
        .sendAccessTokenInHeader(true)
        .sendClientCredentialsInHeader(false)
        .sendSecretInApis(true)
        .tokenUrl('https://auth.atlassian.com/oauth/token');

        AuthProviderService.CreateAuthProviderResponse resp = AuthProviderService.createUpdateAuthProvider(req);
        System.debug(resp);
    }
}