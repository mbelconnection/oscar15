package org.oscarehr.PMmodule.exception;

/**
 * Thrown by the integration manager when unimplemented operations are requested.
 */
public class OperationNotImplementedException extends IntegratorException {

    public OperationNotImplementedException() {
    }

    public OperationNotImplementedException(String s) {
        super(s);
    }

    public OperationNotImplementedException(String s, Throwable throwable) {
        super(s, throwable);
    }

    public OperationNotImplementedException(Throwable throwable) {
        super(throwable);
    }
}
