public with sharing class ResumeAiService {
  private static final String ENDPOINT = 'callout:Talent_AI';

  public class ResumeAnalysis {
    public String fullName;
    public String email;
    public List<String> skills;
    public Integer yearsExperience;
  }

  public class ResumeAiException extends Exception {
  }

  public static ResumeAnalysis parseResume(String resumeText) {
    if (String.isBlank(resumeText)) {
      throw new ResumeAiException('Résumé text is required.');
    }

    HttpRequest request = new HttpRequest();
    request.setEndpoint(ENDPOINT);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    request.setTimeout(20000);
    request.setBody(createRequestBody(resumeText));

    HttpResponse response;

    try {
      response = new Http().send(request);
    } catch (CalloutException exceptionValue) {
      throw new ResumeAiException('AI provider call failed.');
    }

    if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
      throw new ResumeAiException('AI provider returned an error.');
    }

    try {
      ResumeAnalysis result = (ResumeAnalysis) JSON.deserialize(
        response.getBody(),
        ResumeAnalysis.class
      );

      if (
        result == null ||
        String.isBlank(result.fullName) ||
        String.isBlank(result.email) ||
        result.skills == null
      ) {
        throw new ResumeAiException(
          'AI provider returned an incomplete response.'
        );
      }

      return result;
    } catch (ResumeAiException exceptionValue) {
      throw exceptionValue;
    } catch (Exception exceptionValue) {
      throw new ResumeAiException('AI provider returned invalid JSON.');
    }
  }

  private static String createRequestBody(String resumeText) {
    Map<String, Object> requestBody = new Map<String, Object>{
      'resumeText' => resumeText,
      'responseFormat' => 'json'
    };

    return JSON.serialize(requestBody);
  }
}
