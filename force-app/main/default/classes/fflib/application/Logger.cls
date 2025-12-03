/**
 * @description Logger utility for consistent logging across the application
 */
public class Logger {
    
    public enum LogLevel {
        DEBUG,
        INFO,
        WARN,
        ERROR
    }
    
    private static List<LogEntry> logs = new List<LogEntry>();
    private static LogLevel currentLevel = LogLevel.INFO;
    
    /**
     * @description Set the current logging level
     * @param level - The logging level to set
     */
    public static void setLogLevel(LogLevel level) {
        currentLevel = level;
    }
    
    /**
     * @description Log a debug message
     * @param message - The message to log
     */
    public static void debug(String message) {
        if (canLog(LogLevel.DEBUG)) {
            logs.add(new LogEntry(LogLevel.DEBUG, message));
            System.debug(LoggingLevel.DEBUG, message);
        }
    }
    
    /**
     * @description Log an info message
     * @param message - The message to log
     */
    public static void info(String message) {
        if (canLog(LogLevel.INFO)) {
            logs.add(new LogEntry(LogLevel.INFO, message));
            System.debug(LoggingLevel.INFO, message);
        }
    }
    
    /**
     * @description Log a warning message
     * @param message - The message to log
     */
    public static void warn(String message) {
        if (canLog(LogLevel.WARN)) {
            logs.add(new LogEntry(LogLevel.WARN, message));
            System.debug(LoggingLevel.WARN, message);
        }
    }
    
    /**
     * @description Log an error message
     * @param message - The message to log
     */
    public static void error(String message) {
        if (canLog(LogLevel.ERROR)) {
            logs.add(new LogEntry(LogLevel.ERROR, message));
            System.debug(LoggingLevel.ERROR, message);
        }
    }
    
    /**
     * @description Log an error with exception
     * @param message - The message to log
     * @param ex - The exception to log
     */
    public static void error(String message, Exception ex) {
        if (canLog(LogLevel.ERROR)) {
            String errorMsg = message + ': ' + ex.getMessage() + ' (' + ex.getTypeName() + ')';
            logs.add(new LogEntry(LogLevel.ERROR, errorMsg));
            System.debug(LoggingLevel.ERROR, errorMsg);
        }
    }
    
    /**
     * @description Get all logged entries
     * @return List<LogEntry> - All logged entries
     */
    public static List<LogEntry> getLogs() {
        return logs;
    }
    
    /**
     * @description Clear all logs
     */
    public static void clearLogs() {
        logs.clear();
    }
    
    /**
     * @description Check if a message should be logged
     * @param level - The logging level to check
     * @return Boolean - True if the message should be logged
     */
    private static Boolean canLog(LogLevel level) {
        return level.ordinal() >= currentLevel.ordinal();
    }
    
    /**
     * @description Inner class representing a single log entry
     */
    public class LogEntry {
        public LogLevel level;
        public String message;
        public DateTime timestamp;
        
        public LogEntry(LogLevel level, String message) {
            this.level = level;
            this.message = message;
            this.timestamp = System.now();
        }
    }
}
