/*
 * Copyright (c) 2022 FinancialForce.com, inc.  All rights reserved.
 */
/**
 * Implementatio of wrapper around auto-generated metadata service
 * @group PSA Direct for Concur - Metadata
 */
public with sharing class MetadataServiceWrapperImpl implements MetadataServiceWrapper.API {
	@TestVisible
	private static MetadataService.MetadataPort metadataPort;

	private String SessionId {
		get {
			return SessionId == null ? UserInfo.getSessionId() : SessionId;
		}
		set;
	}

	private static Map<String, Object> s_identityServiceData;

	private static Map<String, Object> getIdentityServiceData() {
		if (s_identityServiceData != null)
			return s_identityServiceData;

		String orgId = UserInfo.getOrganizationId();
		String userId = UserInfo.getUserId();
		String sessionId = UserInfo.getSessionId();

		if (sessionId == null)
			return new Map<String, Object>();

		String url = String.format(
			'/id/{0}/{1}',
			new List<String>{ orgId, userId }
		);
		PageReference pageReference = new PageReference(url);
		pageReference.getParameters().put('oauth_token', sessionId);
		pageReference.getParameters().put('format', 'json');

		String data = getPageContent(pageReference);

		s_identityServiceData = (Map<String, Object>) JSON.deserializeUntyped(
			data
		);

		return s_identityServiceData;
	}

	private static String getPageContent(PageReference pageReference) {
		// PageReference.getContent cannot be invoked in tests, not even mocked.
		// We use a callout instead as the platform will force us to mock it.

		if (Test.isRunningTest()) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint(pageReference.getUrl());
			request.setMethod('GET');

			return new Http().send(request).getBody();
		}

		return pageReference.getContent().toString();
	}

	private static String getIdentityServiceMetadataApiUrl() {
		Map<String, Object> identityServiceData = getIdentityServiceData();
		Map<String, Object> urls = (Map<String, Object>) identityServiceData.get(
			'urls'
		);
		return urls != null ? (String) urls.get('metadata') : null;
	}

	private String getRequestUrl() {
		return getMetadataApiUrl(
				MetadataServiceWrapper.METADATA_API_VERSION
			)
			.toExternalForm();
	}

	private static String getFallbackMetadataApiUrl() {
		String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		return String.format(
			'{0}/services/Soap/m/{1}',
			new List<String>{ baseUrl, '{version}' }
		);
	}

	public Url getMetadataApiUrl(Integer version) {
		String format = getIdentityServiceMetadataApiUrl();

		if (format == null) {
			format = getFallbackMetadataApiUrl();
		}

		String urlString = format.replace('{version}', String.valueOf(version));

		return new Url(urlString);
	}

	@TestVisible
	private MetadataService.MetadataPort getMetadataPort() {
		if (metadataPort == null) {
			metadataPort = new MetadataService.MetadataPort();
			metadataPort.endpoint_x = getRequestUrl();
			metadataPort.timeout_x = MetadataServiceWrapper.TIMEOUT_MILLIS;
			metadataPort.SessionHeader = new MetadataService.SessionHeader_element();
		}
		metadataPort.SessionHeader.sessionId = SessionId;

		return metadataPort;
	}

	public MetadataService.SaveResult[] createMetadata(
		MetadataService.Metadata[] metadata
	) {
		return getMetadataPort().createMetadata(metadata);
	}

	public MetadataService.UpsertResult[] upsertMetadata(
		MetadataService.Metadata[] metadata
	) {
		return getMetadataPort().upsertMetadata(metadata);
	}

	public MetadataService.DeleteResult[] deleteMetadata(
		String type_x,
		String[] fullNames
	) {
		return getMetadataPort().deleteMetadata(type_x, fullNames);
	}

	public MetadataService.IReadResult readMetadata(
		String type_x,
		String[] fullNames
	) {
		return getMetadataPort().readMetadata(type_x, fullNames);
	}

	public MetadataService.FileProperties[] listMetadata(String type_x) {
		MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
		query.type_x = type_x;
		return getMetadataPort()
			.listMetadata(
				new List<MetadataService.ListMetadataQuery>{ query },
				52
			);
	}
}