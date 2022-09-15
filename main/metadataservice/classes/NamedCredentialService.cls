/*
 * Copyright (c) 2022 FinancialForce.com, inc. All rights reserved.
 */
public with sharing class NamedCredentialService {
	@TestVisible
	private static final Dependency implementation = new Dependency(
		'NamedCredentialServiceImpl'
	);

	public enum NamedCredentialType {
		NAMED_PRINCIPAL
	}

	public with sharing class NamedCredentialConfiguration {
		public String fullName;
		public String label;
		public String endPoint;
		public String username;
		public String password;
		public String namespacePrefix; // Used for lookup. Created metadata records automatically get this added.
	}

	public interface API {
		NamedCredentialConfiguration getExistingNameCredential(String fullName);
		MetadataService.UpsertResult createNamedCredential(
			NamedCredentialType type,
			NamedCredentialConfiguration configuration,
			Boolean updateExisting
		);
		void deleteNamedCredentials(String[] fullNames);
		String[] listNamedCredentials();
	}

	public static NamedCredentialConfiguration getExistingNameCredential(
		String fullName
	) {
		return impl().getExistingNameCredential(fullName);
	}

	public static MetadataService.UpsertResult createNamedCredential(
		NamedCredentialType type,
		NamedCredentialConfiguration configuration,
		Boolean updateExisting
	) {
		return impl()
			.createNamedCredential(type, configuration, updateExisting);
	}

	@SuppressWarnings(
		'Unused'
	) // This is currently unused but may be used in future (when mutliple servers are supported)
	public static void deleteNamedCredentials(String[] fullNames) {
		impl().deleteNamedCredentials(fullNames);
	}

	/**
	 * Returns a list of named credential full names
	 */
	public static String[] listNamedCredentials() {
		return impl().listNamedCredentials();
	}

	public class NamedCredentialException extends Exception {
	}

	private static API impl() {
		return (API) implementation.newInstance();
	}

	@TestVisible
	private NamedCredentialService() {
	}

}