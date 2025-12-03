/**
 * @description Application class - Service Locator Pattern for dependency injection
 * Manages instances of Selectors, Domain objects, and Service classes
 */
public class Application {
    
    // Instance variables for singleton pattern
    private static Application instance;
    
    // Maps to store domain, selector, and service class instances
    private Map<Type, Object> domainMap = new Map<Type, Object>();
    private Map<Type, Object> selectorMap = new Map<Type, Object>();
    private Map<Type, Object> serviceMap = new Map<Type, Object>();
    
    /**
     * @description Private constructor to enforce singleton pattern
     */
    private Application() {
    }
    
    /**
     * @description Get the singleton instance of the Application class
     * @return Application - The singleton instance
     */
    public static Application getInstance() {
        if (instance == null) {
            instance = new Application();
        }
        return instance;
    }
    
    /**
     * @description Register a domain class instance
     * @param domainType - The type of the domain class
     * @param domainInstance - The instance of the domain class
     */
    public void registerDomain(Type domainType, Object domainInstance) {
        domainMap.put(domainType, domainInstance);
    }
    
    /**
     * @description Get a domain class instance
     * @param domainType - The type of the domain class to retrieve
     * @return Object - The domain class instance
     */
    public Object getDomain(Type domainType) {
        return domainMap.get(domainType);
    }
    
    /**
     * @description Register a selector class instance
     * @param selectorType - The type of the selector class
     * @param selectorInstance - The instance of the selector class
     */
    public void registerSelector(Type selectorType, Object selectorInstance) {
        selectorMap.put(selectorType, selectorInstance);
    }
    
    /**
     * @description Get a selector class instance
     * @param selectorType - The type of the selector class to retrieve
     * @return Object - The selector class instance
     */
    public Object getSelector(Type selectorType) {
        return selectorMap.get(selectorType);
    }
    
    /**
     * @description Register a service class instance
     * @param serviceType - The type of the service class
     * @param serviceInstance - The instance of the service class
     */
    public void registerService(Type serviceType, Object serviceInstance) {
        serviceMap.put(serviceType, serviceInstance);
    }
    
    /**
     * @description Get a service class instance
     * @param serviceType - The type of the service class to retrieve
     * @return Object - The service class instance
     */
    public Object getService(Type serviceType) {
        return serviceMap.get(serviceType);
    }
    
    /**
     * @description Clear all registered instances (useful for testing)
     */
    public void clearRegistrations() {
        domainMap.clear();
        selectorMap.clear();
        serviceMap.clear();
    }
}
