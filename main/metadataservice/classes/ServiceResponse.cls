/*
 * Copyright (c) 2022 FinancialForce.com, inc. All rights reserved.
 */
/**
 * Base class for responses from service requests
 */
public abstract class ServiceResponse {
    private String error;
    private Boolean ok;
    private String warning;

    public ServiceResponse() {
        this(true);
    }

    public ServiceResponse(
        Boolean isOk
    ) {
        this(isOk, null, null);
    }

    public ServiceResponse(
        Boolean isOk,
        String warning,
        String error
    ) {
        this.ok = isOk;
        this.warning = warning;
        this.error = error;
    }

    public String getError() {
        return error;
    }

    public String getWarning() {
        return warning;
    }

    public Boolean isOk() {
        return ok;
    }
}