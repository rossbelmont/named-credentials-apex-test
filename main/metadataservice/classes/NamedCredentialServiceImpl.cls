/*
 * Copyright (c) 2021 FinancialForce.com, inc.  All rights reserved.
 */
/**
 * Implementation of abstraction layer for handling named credentials
 */
public with sharing class NamedCredentialServiceImpl implements NamedCredentialService.API {
	@TestVisible
	private static final String NAMED_CREDENTIAL_TYPE = 'NamedCredential';

	public NamedCredentialService.NamedCredentialConfiguration getExistingNameCredential(
		String fullName
	) {
		MetadataService.IReadResult result = MetadataServiceWrapper.readMetadata(
			NAMED_CREDENTIAL_TYPE,
			new List<String>{ fullName }
		);
		MetadataService.Metadata[] records = result.getRecords();
		if (null != records && !(records.isEmpty())) {
			MetadataService.Metadata record = records.get(0);
			if (record instanceof MetadataService.NamedCredential) {
				MetadataService.NamedCredential nc = (MetadataService.NamedCredential) record;
				NamedCredentialService.NamedCredentialConfiguration conf = new NamedCredentialService.NamedCredentialConfiguration();
				conf.fullName = nc.fullName;
				conf.label = nc.label;
				conf.endPoint = nc.endpoint;
				conf.username = nc.username;
				return conf;
			}
		}
		return null;
	}

	public MetadataService.UpsertResult createNamedCredential(
		NamedCredentialService.NamedCredentialType type,
		NamedCredentialService.NamedCredentialConfiguration configuration,
		Boolean updateExisting
	) {
		if (null == type) {
			throw new NamedCredentialService.NamedCredentialException(
				'type may not by null'
			);
		}
		if (null == configuration) {
			throw new NamedCredentialService.NamedCredentialException(
				'configuration may not by null'
			);
		}
		if (null == configuration.fullName) {
			throw new NamedCredentialService.NamedCredentialException(
				'configuration.fullName may not by null'
			);
		}

		// Get any existing named credential
		MetadataService.NamedCredential existingCred = null;
		String name = configuration.fullName;
		if (
			null != configuration.namespacePrefix &&
			configuration.namespacePrefix.length() > 0
		) {
			name = configuration.namespacePrefix + '__' + name;
		}
		MetadataService.IReadResult result = MetadataServiceWrapper.readMetadata(
			NAMED_CREDENTIAL_TYPE,
			new List<String>{ name }
		);
		MetadataService.Metadata[] records = result.getRecords();
		if (null != records && !(records.isEmpty())) {
			MetadataService.Metadata record = records.get(0);
			if (record instanceof MetadataService.NamedCredential) {
				MetadataService.NamedCredential nc = (MetadataService.NamedCredential) record;
				// Note the query will actually always return a value (the above check is just in case the metadata service ever acts rationally in future!): check the name actually matches the request
				if (nc.fullName == configuration.fullName) {
					if (updateExisting == false) {
						throw new NamedCredentialService.NamedCredentialException(
							'Existing record with same fullName found and updateExisting is false'
						);
					}
					existingCred = (MetadataService.NamedCredential) record;
				}
			}
		}

		switch on type {
			when NAMED_PRINCIPAL {
				return createNamedPrincipalWithUsernamePassword(
					existingCred,
					configuration
				);
			}
			when else {
				throw new NamedCredentialService.NamedCredentialException(
					'unsupported type'
				);
			}
		}
	}

	public void deleteNamedCredentials(String[] fullNames) {
		if (null == fullNames || fullNames.isEmpty()) {
			return;
		}
		MetadataServiceWrapper.deleteMetadata(
			NAMED_CREDENTIAL_TYPE,
			fullNames
		);
	}

	public String[] listNamedCredentials() {
		MetadataService.FileProperties[] props = MetadataServiceWrapper.listMetadata(
			NAMED_CREDENTIAL_TYPE
		);
		List<String> namedCredentialFullNames = new List<String>();
		for (MetadataService.FileProperties prop : props) {
			namedCredentialFullNames.add(prop.fullName);
		}
		return namedCredentialFullNames;
	}

	private static MetadataService.UpsertResult createNamedPrincipalWithUsernamePassword(
		MetadataService.NamedCredential existingCred,
		NamedCredentialService.NamedCredentialConfiguration configuration
	) {
		MetadataService.NamedCredential cred = existingCred;
		if (null == cred) {
			cred = new MetadataService.NamedCredential();
		}
		cred.fullName = configuration.fullName;
		if (null != configuration.label) {
			// Allow for updates to username and password only
			cred.label = configuration.label;
		}
		cred.allowMergeFieldsInBody = false;
		cred.allowMergeFieldsInHeader = true;
		cred.generateAuthorizationHeader = true;
		cred.principalType = 'NamedUser';
		cred.protocol = 'Password';
		cred.password = configuration.password;
		cred.username = configuration.username;
		if (null != configuration.endpoint) {
			// Allow for updates to username and password only
			cred.endpoint = configuration.endpoint;
		}
		return (MetadataServiceWrapper.upsertMetadata(
				new List<MetadataService.Metadata>{ cred }
			)
			.get(0));
	}
}