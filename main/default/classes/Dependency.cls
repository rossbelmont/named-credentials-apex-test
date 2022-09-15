/*
 * Copyright (c) 2022 FinancialForce.com, inc. All rights reserved.
 */
public with sharing class Dependency {
	@TestVisible
	private String m_implementationTypeName;
	@TestVisible
	private Type m_dependencyImplType;
	@TestVisible
	private Object m_mockDependency;

	/**
	 * Constructs a simple Dependency
	 *
	 * @param implementationTypeName The type name of the implementation needed for this service instance
	 **/
	public Dependency(String implementationTypeName) {
		m_implementationTypeName = implementationTypeName;
	}

	/**
	 * Returns a new instance of the Apex class from the implementation passed in the constructor
	 **/
	public Object newInstance() {
		// Mock implementation?
		if (m_mockDependency != null)
			return m_mockDependency;

		if (m_dependencyImplType == null) {
			m_dependencyImplType = Type.forName(m_implementationTypeName);
			if (m_dependencyImplType == null) {
				throw new DependencyException(
					'Failed to find dependency class: ' +
					m_implementationTypeName
				);
			}
		}

		return m_dependencyImplType.newInstance();
	}

	@TestVisible
	private void setMock(Object mockDependency) {
		m_mockDependency = mockDependency;
	}

	public with sharing class DependencyException extends Exception {
	}
}