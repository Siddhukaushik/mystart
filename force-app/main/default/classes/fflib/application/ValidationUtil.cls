/**
 * @description Validation utility for common validation operations
 */
public class ValidationUtil {
    
    /**
     * @description Check if a string is blank
     * @param value - The string to check
     * @return Boolean - True if blank or null
     */
    public static Boolean isBlank(String value) {
        return String.isBlank(value);
    }
    
    /**
     * @description Check if a string is not blank
     * @param value - The string to check
     * @return Boolean - True if not blank
     */
    public static Boolean isNotBlank(String value) {
        return String.isNotBlank(value);
    }
    
    /**
     * @description Check if a collection is empty
     * @param collection - The collection to check
     * @return Boolean - True if empty or null
     */
    public static Boolean isEmpty(Collection<Object> collection) {
        return collection == null || collection.isEmpty();
    }
    
    /**
     * @description Check if a collection is not empty
     * @param collection - The collection to check
     * @return Boolean - True if not empty
     */
    public static Boolean isNotEmpty(Collection<Object> collection) {
        return collection != null && !collection.isEmpty();
    }
    
    /**
     * @description Validate email format
     * @param email - The email to validate
     * @return Boolean - True if valid email format
     */
    public static Boolean isValidEmail(String email) {
        if (String.isBlank(email)) {
            return false;
        }
        
        String emailPattern = '^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        return Pattern.matches(emailPattern, email);
    }
    
    /**
     * @description Validate phone number format (basic)
     * @param phone - The phone to validate
     * @return Boolean - True if valid phone format
     */
    public static Boolean isValidPhone(String phone) {
        if (String.isBlank(phone)) {
            return false;
        }
        
        String cleanPhone = phone.replaceAll('[^0-9]', '');
        return cleanPhone.length() >= 10;
    }
    
    /**
     * @description Check if a value is null
     * @param value - The value to check
     * @return Boolean - True if null
     */
    public static Boolean isNull(Object value) {
        return value == null;
    }
    
    /**
     * @description Check if a value is not null
     * @param value - The value to check
     * @return Boolean - True if not null
     */
    public static Boolean isNotNull(Object value) {
        return value != null;
    }
    
    /**
     * @description Validate that required fields are populated
     * @param record - The SObject to validate
     * @param requiredFields - Set of required field names
     * @return Boolean - True if all required fields are populated
     */
    public static Boolean validateRequiredFields(SObject record, Set<String> requiredFields) {
        if (record == null || isEmpty(requiredFields)) {
            return false;
        }
        
        for (String fieldName : requiredFields) {
            if (record.get(fieldName) == null) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * @description Validate record count is within limits
     * @param count - The count to validate
     * @param maxLimit - The maximum allowed count
     * @return Boolean - True if count is within limit
     */
    public static Boolean isWithinLimit(Integer count, Integer maxLimit) {
        return count >= 0 && count <= maxLimit;
    }
}
