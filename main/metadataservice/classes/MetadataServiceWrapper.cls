/*
 * Copyright (c) 2022 FinancialForce.com, inc.  All rights reserved.
 */
/**
 * Wrapper around auto-generated metadata service
 * @group PSA Direct for Concur - Metadata
 */
public with sharing class MetadataServiceWrapper {
	public static final Integer METADATA_API_VERSION = 56;
	public static final Integer TIMEOUT_MILLIS = 120000; //Give the platform the maximum time to perform the callout.

	@TestVisible
	private static final Dependency implementation = new Dependency(
		'MetadataServiceWrapperImpl'
	);

	public interface API {
		MetadataService.SaveResult[] createMetadata(
			MetadataService.Metadata[] metadata
		);
		MetadataService.UpsertResult[] upsertMetadata(
			MetadataService.Metadata[] metadata
		);
		MetadataService.DeleteResult[] deleteMetadata(
			String type_x,
			String[] fullNames
		);
		MetadataService.IReadResult readMetadata(
			String type_x,
			String[] fullNames
		);
		MetadataService.FileProperties[] listMetadata(String type_x);
	}

	public static MetadataService.SaveResult[] createMetadata(
		MetadataService.Metadata[] metadata
	) {
		return impl().createMetadata(metadata);
	}

	public static MetadataService.UpsertResult[] upsertMetadata(
		MetadataService.Metadata[] metadata
	) {
		return impl().upsertMetadata(metadata);
	}

	public static MetadataService.DeleteResult[] deleteMetadata(
		String type_x,
		String[] fullNames
	) {
		return impl().deleteMetadata(type_x, fullNames);
	}

	public static MetadataService.IReadResult readMetadata(
		String type_x,
		String[] fullNames
	) {
		return impl().readMetadata(type_x, fullNames);
	}

	public static MetadataService.FileProperties[] listMetadata(
		String type_x
	) {
		return impl().listMetadata(type_x);
	}

	private static API impl() {
		return (API) implementation.newInstance();
	}

	@TestVisible
	private MetadataServiceWrapper() {
	}
}