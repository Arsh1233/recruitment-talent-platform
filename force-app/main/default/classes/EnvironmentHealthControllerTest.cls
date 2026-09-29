@IsTest
private class EnvironmentHealthControllerTest {
  @IsTest
  static void returnsReadyStatus() {
    Test.startTest();
    String result = EnvironmentHealthController.getStatus();
    Test.stopTest();

    System.assertEquals('READY', result);
  }
}
