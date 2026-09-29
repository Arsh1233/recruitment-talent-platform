@IsTest
private class ResumeAiServiceTest {
  private class ResponseMock implements HttpCalloutMock {
    private Integer statusCode;
    private String responseBody;
    private Boolean simulateTimeout;

    ResponseMock(
      Integer statusCode,
      String responseBody,
      Boolean simulateTimeout
    ) {
      this.statusCode = statusCode;
      this.responseBody = responseBody;
      this.simulateTimeout = simulateTimeout;
    }

    public HttpResponse respond(HttpRequest request) {
      System.assertEquals('callout:Talent_AI', request.getEndpoint());
      System.assertEquals('POST', request.getMethod());

      if (simulateTimeout) {
        throw new CalloutException('Simulated timeout');
      }

      HttpResponse response = new HttpResponse();
      response.setStatusCode(statusCode);
      response.setHeader('Content-Type', 'application/json');
      response.setBody(responseBody);
      return response;
    }
  }

  @IsTest
  static void parsesValidResponse() {
    String validJson =
      '{"fullName":"Jordan Lee",' +
      '"email":"jordan.lee@example.invalid",' +
      '"skills":["Apex","Salesforce"],' +
      '"yearsExperience":4}';

    Test.setMock(
      HttpCalloutMock.class,
      new ResponseMock(200, validJson, false)
    );

    ResumeAiService.ResumeAnalysis result = ResumeAiService.parseResume(
      'Synthetic résumé for fictional candidate Jordan Lee.'
    );

    System.assertEquals('Jordan Lee', result.fullName);
    System.assertEquals('jordan.lee@example.invalid', result.email);
    System.assertEquals(2, result.skills.size());
    System.assertEquals(4, result.yearsExperience);
  }

  @IsTest
  static void rejectsMalformedJson() {
    Test.setMock(
      HttpCalloutMock.class,
      new ResponseMock(200, '{invalid-json', false)
    );

    try {
      ResumeAiService.parseResume('Synthetic résumé');
      System.assert(false, 'Expected invalid JSON to be rejected.');
    } catch (ResumeAiService.ResumeAiException exceptionValue) {
      System.assertEquals(
        'AI provider returned invalid JSON.',
        exceptionValue.getMessage()
      );
    }
  }

  @IsTest
  static void rejectsIncompleteResponse() {
    Test.setMock(
      HttpCalloutMock.class,
      new ResponseMock(
        200,
        '{"fullName":"Jordan Lee","email":"jordan.lee@example.invalid"}',
        false
      )
    );

    try {
      ResumeAiService.parseResume('Synthetic résumé');
      System.assert(false, 'Expected incomplete response to be rejected.');
    } catch (ResumeAiService.ResumeAiException exceptionValue) {
      System.assertEquals(
        'AI provider returned an incomplete response.',
        exceptionValue.getMessage()
      );
    }
  }

  @IsTest
  static void handlesHttpError() {
    Test.setMock(
      HttpCalloutMock.class,
      new ResponseMock(500, '{"error":"temporary failure"}', false)
    );

    try {
      ResumeAiService.parseResume('Synthetic résumé');
      System.assert(false, 'Expected HTTP error handling.');
    } catch (ResumeAiService.ResumeAiException exceptionValue) {
      System.assertEquals(
        'AI provider returned an error.',
        exceptionValue.getMessage()
      );
    }
  }

  @IsTest
  static void handlesTimeout() {
    Test.setMock(HttpCalloutMock.class, new ResponseMock(0, null, true));

    try {
      ResumeAiService.parseResume('Synthetic résumé');
      System.assert(false, 'Expected timeout handling.');
    } catch (ResumeAiService.ResumeAiException exceptionValue) {
      System.assertEquals(
        'AI provider call failed.',
        exceptionValue.getMessage()
      );
    }
  }
}
