public with sharing class EnvironmentHealthController {
  @AuraEnabled(cacheable=true)
  public static String getStatus() {
    return 'READY';
  }
}
