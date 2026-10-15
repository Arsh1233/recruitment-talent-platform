@IsTest
private class RTPRecordSharingServiceTest {
    @TestSetup
    static void createUsers() {
        Profile profileRecord = [SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId()];
        String stamp = String.valueOf(DateTime.now().getTime());
        List<User> users = new List<User>();
        for (String roleName : new List<String>{
            'Recruiter One', 'Recruiter Two', 'Manager One', 'Manager Two',
            'Interviewer One', 'Interviewer Two', 'Employee User'
        }) {
            String token = roleName.replace(' ', '').toLowerCase();
            users.add(new User(
                Alias = token.left(8),
                Email = token + '.' + stamp + '@example.invalid',
                EmailEncodingKey = 'UTF-8',
                LastName = roleName,
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = profileRecord.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = token + '.' + stamp + '@example.invalid'
            ));
        }
        insert users;

        PermissionSet interviewerPermission = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'RTP_Interviewer_Access'
            LIMIT 1
        ];
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
        for (User userRecord : users) {
            if (userRecord.LastName.startsWith('Interviewer')) {
                assignments.add(new PermissionSetAssignment(
                    AssigneeId = userRecord.Id,
                    PermissionSetId = interviewerPermission.Id
                ));
            }
        }
        insert assignments;
    }

    @IsTest
    static void buildsAndReplacesInternalShares() {
        Map<String, User> usersByName = new Map<String, User>();
        for (User userRecord : [
            SELECT Id, LastName
            FROM User
            WHERE LastName IN (
                'Recruiter One', 'Recruiter Two', 'Manager One', 'Manager Two',
                'Interviewer One', 'Interviewer Two', 'Employee User'
            )
        ]) {
            usersByName.put(userRecord.LastName, userRecord);
        }

        Account candidateAccount = new Account(Name = 'RTP Test Candidate Account');
        insert candidateAccount;
        Contact portalContact = new Contact(
            AccountId = candidateAccount.Id,
            FirstName = 'Jordan',
            LastName = 'Lee',
            Email = 'jordan.sharing.test@example.invalid'
        );
        insert portalContact;

        Department__c department = new Department__c(
            Name = 'Sharing Test Department',
            Department_code__c = 'SHARE-' + String.valueOf(DateTime.now().getTime())
        );
        insert department;
        Position__c position = new Position__c(
            Name = 'Sharing Test Position',
            Department__c = department.Id,
            Position_code__c = 'SHARE-POS-' + String.valueOf(DateTime.now().getTime()),
            Job_Level__c = 'Senior'
        );
        insert position;
        Candidate__c candidate = new Candidate__c(
            Contact__c = portalContact.Id,
            First_Name__c = 'Jordan',
            Last_Name__c = 'Lee',
            Email__c = 'jordan.sharing.test@example.invalid',
            Profile_Status__c = 'Incomplete'
        );
        insert candidate;

        Job_Requisition__c requisition = new Job_Requisition__c(
            Department__c = department.Id,
            Position__c = position.Id,
            Number_of_Openings__c = 1,
            Version_Number__c = 1,
            Status__c = 'Approved',
            Approved_By__c = UserInfo.getUserId(),
            Approved_At__c = System.now(),
            Assigned_Recruiter__c = usersByName.get('Recruiter One').Id,
            Hiring_Manager__c = usersByName.get('Manager One').Id
        );
        insert requisition;
        Job_Opening__c opening = new Job_Opening__c(
            Requisition__c = requisition.Id,
            Position__c = position.Id,
            Status__c = 'Draft',
            Number_of_Openings__c = 1,
            Number_Filled__c = 0,
            Assigned_Recruiter__c = usersByName.get('Recruiter One').Id
        );
        insert opening;
        Job_Application__c application = new Job_Application__c(
            Candidate__c = candidate.Id,
            Job_Opening__c = opening.Id,
            Status__c = 'Draft',
            Assigned_Recruiter__c = usersByName.get('Recruiter One').Id
        );
        insert application;
        interview__c interviewRecord = new interview__c(
            Application__c = application.Id,
            Round_Number__c = 1,
            Status__c = 'Planned',
            Primary_Interviewer__c = usersByName.get('Interviewer One').Id
        );
        insert interviewRecord;

        Id evaluationId;
        System.runAs(usersByName.get('Interviewer One')) {
            RTPInterviewEvaluationService.EvaluationInput evaluationInput =
                new RTPInterviewEvaluationService.EvaluationInput();
            evaluationInput.interviewId = interviewRecord.Id;
            evaluationInput.technicalScore = 4;
            evaluationInput.problemSolvingScore = 4;
            evaluationInput.experienceScore = 4;
            evaluationInput.communicationScore = 4;
            evaluationInput.roleSuitabilityScore = 4;
            evaluationInput.recommendation = 'Hire';
            evaluationInput.comments = 'Synthetic evaluation for access testing.';
            evaluationInput.submitted = true;
            evaluationId = RTPInterviewEvaluationService.saveMyEvaluation(
                evaluationInput
            );
            RTPInterviewEvaluationService.EvaluationView myEvaluation =
                RTPInterviewEvaluationService.getMyEvaluation(interviewRecord.Id);
            System.assertEquals(evaluationId, myEvaluation.id);
            System.assertEquals('Hire', myEvaluation.recommendation);
        }
        System.runAs(usersByName.get('Interviewer Two')) {
            Boolean accessDenied = false;
            try {
                RTPInterviewEvaluationService.EvaluationInput crossUserInput =
                    new RTPInterviewEvaluationService.EvaluationInput();
                crossUserInput.id = evaluationId;
                crossUserInput.interviewId = interviewRecord.Id;
                crossUserInput.comments = 'Attempted cross-interviewer edit.';
                RTPInterviewEvaluationService.saveMyEvaluation(
                    crossUserInput
                );
            } catch (AuraHandledException expected) {
                accessDenied = true;
            }
            System.assert(accessDenied, 'A different interviewer must not edit the evaluation.');
        }

        Offer__c offerRecord = new Offer__c(
            Application__c = application.Id,
            Version_Number__c = 1,
            Status__c = 'Draft'
        );
        insert offerRecord;

        Employee__c employee = new Employee__c(
            User__c = usersByName.get('Employee User').Id,
            Candidate__c = candidate.Id,
            Department__c = department.Id,
            Position__c = position.Id,
            Employee_Number__c = 'SHARE-EMP-' + String.valueOf(DateTime.now().getTime()),
            Employment_Type__c = 'Permanent',
            Employment_Status__c = 'Active'
        );
        insert employee;
        Critical_Position__c criticalPosition = new Critical_Position__c(
            Position__c = position.Id,
            Department__c = department.Id,
            Is_Active__c = true,
            Target_Successor_Count__c = 1
        );
        insert criticalPosition;
        Succession_Nomination__c nomination = new Succession_Nomination__c(
            Critical_Position__c = criticalPosition.Id,
            Employee__c = employee.Id,
            Status__c = 'Proposed',
            Nomination_Date__c = Date.today()
        );
        insert nomination;

        RTPRecordSharingService.rebuildAll();

        Id recruiterGroupId = [
            SELECT Id FROM Group
            WHERE DeveloperName = 'RTP_All_Recruiters' AND Type = 'Regular'
            LIMIT 1
        ].Id;
        Id successionGroupId = [
            SELECT Id FROM Group
            WHERE DeveloperName = 'RTP_Succession_Committee' AND Type = 'Regular'
            LIMIT 1
        ].Id;

        assertShare('Job_Requisition__Share', requisition.Id, recruiterGroupId, 'Recruitment_Team__c', 'Edit', 1);
        assertShare('Job_Requisition__Share', requisition.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Edit', 1);
        assertShare('Job_Requisition__Share', requisition.Id, usersByName.get('Manager One').Id, 'Hiring_Manager_Assignment__c', 'Edit', 1);
        assertShare('Job_Opening__Share', opening.Id, recruiterGroupId, 'Recruitment_Team__c', 'Edit', 1);
        assertShare('Job_Application__Share', application.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Edit', 1);
        assertShare('Job_Application__Share', application.Id, usersByName.get('Manager One').Id, 'Hiring_Manager_Assignment__c', 'Edit', 1);
        assertShare('Job_Application__Share', application.Id, usersByName.get('Interviewer One').Id, 'Interviewer_Assignment__c', 'Read', 1);
        assertShare('Candidate__Share', candidate.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Read', 1);
        assertShare('Candidate__Share', candidate.Id, usersByName.get('Manager One').Id, 'Hiring_Manager_Assignment__c', 'Read', 1);
        assertShare('Candidate__Share', candidate.Id, usersByName.get('Interviewer One').Id, 'Interviewer_Assignment__c', 'Read', 1);
        assertShare('interview__Share', interviewRecord.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Edit', 1);
        assertShare('interview__Share', interviewRecord.Id, usersByName.get('Manager One').Id, 'Hiring_Manager_Assignment__c', 'Read', 1);
        assertShare('interview__Share', interviewRecord.Id, usersByName.get('Interviewer One').Id, 'Interviewer_Assignment__c', 'Read', 1);
        assertShare('Offer__Share', offerRecord.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Edit', 1);
        assertShare('Critical_Position__Share', criticalPosition.Id, successionGroupId, 'Succession_Committee__c', 'Read', 1);
        assertShare('Succession_Nomination__Share', nomination.Id, successionGroupId, 'Succession_Committee__c', 'Edit', 1);
        assertShare('Succession_Nomination__Share', nomination.Id, usersByName.get('Employee User').Id, 'Succession_Committee__c', 'Edit', 0);

        requisition.Assigned_Recruiter__c = usersByName.get('Recruiter Two').Id;
        requisition.Hiring_Manager__c = usersByName.get('Manager Two').Id;
        opening.Assigned_Recruiter__c = usersByName.get('Recruiter Two').Id;
        application.Assigned_Recruiter__c = usersByName.get('Recruiter Two').Id;
        interviewRecord.Primary_Interviewer__c = usersByName.get('Interviewer Two').Id;
        update requisition;
        update opening;
        update application;
        update interviewRecord;

        RTPRecordSharingService.rebuildAll();

        assertShare('Job_Application__Share', application.Id, usersByName.get('Recruiter One').Id, 'Recruiter_Assignment__c', 'Edit', 0);
        assertShare('Job_Application__Share', application.Id, usersByName.get('Recruiter Two').Id, 'Recruiter_Assignment__c', 'Edit', 1);
        assertShare('Candidate__Share', candidate.Id, usersByName.get('Manager One').Id, 'Hiring_Manager_Assignment__c', 'Read', 0);
        assertShare('Candidate__Share', candidate.Id, usersByName.get('Manager Two').Id, 'Hiring_Manager_Assignment__c', 'Read', 1);
        assertShare('interview__Share', interviewRecord.Id, usersByName.get('Interviewer One').Id, 'Interviewer_Assignment__c', 'Read', 0);
        assertShare('interview__Share', interviewRecord.Id, usersByName.get('Interviewer Two').Id, 'Interviewer_Assignment__c', 'Read', 1);

        Test.startTest();
        RTPRecordSharingService.requestRebuild();
        Test.stopTest();
    }

    private static void assertShare(
        String shareObject,
        Id parentId,
        Id granteeId,
        String rowCause,
        String accessLevel,
        Integer expectedCount
    ) {
        Integer actualCount = Database.countQuery(
            'SELECT COUNT() FROM ' + shareObject +
            ' WHERE ParentId = :parentId' +
            ' AND UserOrGroupId = :granteeId' +
            ' AND RowCause = :rowCause' +
            ' AND AccessLevel = :accessLevel'
        );
        System.assertEquals(
            expectedCount,
            actualCount,
            'Unexpected share state for ' + shareObject + ' / ' + rowCause
        );
    }
}
