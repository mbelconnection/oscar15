package org.oscarehr.PMmodule.exception;

/**
 * Thrown in the circumstance where the remote integrator service is requested
 * but not properly initialized.
 */
public class IntegratorNotInitializedException extends IntegratorException {
    public IntegratorNotInitializedException() {
        super();    //To change body of overridden methods use File | Settings | File Templates.
    }

    public IntegratorNotInitializedException(String msg) {
        super(msg);    //To change body of overridden methods use File | Settings | File Templates.
    }

    public IntegratorNotInitializedException(String s, Throwable throwable) {
        super(s, throwable);    //To change body of overridden methods use File | Settings | File Templates.
    }

    public IntegratorNotInitializedException(Throwable throwable) {
        super(throwable);    //To change body of overridden methods use File | Settings | File Templates.
    }
}
