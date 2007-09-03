package org.oscarehr.util;

import org.springframework.beans.factory.BeanFactory;

/**
 * This class holds utilities used to work with spring.
 * The main usage is probably the beanFactory singleton.
 */
public class SpringUtils {
    //    private static final String[] configs = {"/applicationContext.xml", "/applicationContextCaisi.xml"};
    //    public static final BeanFactory beanFactory = new ClassPathXmlApplicationContext(configs);
    
    public static BeanFactory beanFactory = null;
}
