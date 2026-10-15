@IsTest
private class RTPStep9PortalSecurityTest {
    @TestSetup
    static void createData() {
        Profile profileRecord = [
            SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId()
        ];
        String stamp = String.valueOf(DateTime.now().getTime());
        List<User> users = new List<User>{
            new User(
                Alias = 'porta',
                Email = 'portal.a.' + stamp + '@example.invalid',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Portal Candidate A',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = profileRecord.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = 'portal.a.' + stamp + '@example.invalid'
            ),
            new User(
                Alias = 'portb',
                Email = 'portal.b.' + stamp + '@example.invalid',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Portal Candidate B',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = profileRecord.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = 'portal.b.' + stamp + '@example.invalid'
            )
        };
        insert users;

        System.runAs(users[0]) {
        Account candidateAccount = new Account(Name = 'Step 9 Candidate Account');
        insert candidateAccount;
        List<Contact> contacts = new List<Contact>{
            new Contact(
                AccountId = candidateAccount.Id,
                FirstName = 'Jordan',
                LastName = 'Lee',
                Email = 'jordan.step9@example.invalid'
            ),
            new Contact(
                AccountId = candidateAccount.Id,
                FirstName = 'Morgan',
                LastName = 'Patel',
                Email = 'morgan.step9@example.invalid'
            )
        };
        insert contacts;

        List<Candidate__c> candidates = new List<Candidate__c>{
            new Candidate__c(
                Contact__c = contacts[0].Id,
                First_Name__c = 'Jordan',
                Last_Name__c = 'Lee',
                Email__c = 'jordan.step9@example.invalid',
                Phone__c = '+1 555 010 1001',
                Profile_Status__c = 'Incomplete'
            ),
            new Candidate__c(
                Contact__c = contacts[1].Id,
                First_Name__c = 'Morgan',
                Last_Name__c = 'Patel',
                Email__c = 'morgan.step9@example.invalid',
                Phone__c = '+1 555 010 1002',
                Profile_Status__c = 'Incomplete'
            )
        };
        insert candidates;

        Department__c department = new Department__c(
            Name = 'Step 9 Security Department',
            Department_code__c = 'SEC9-' + stamp
        );
        insert department;
        Position__c position = new Position__c(
            Name = 'Step 9 Security Position',
            Department__c = department.Id,
            Position_code__c = 'SEC9-POS-' + stamp,
            Job_Level__c = 'Senior'
        );
        insert position;
        Job_Requisition__c requisition = new Job_Requisition__c(
            Department__c = department.Id,
            Position__c = position.Id,
            Number_of_Openings__c = 3,
            Version_Number__c = 1,
            Status__c = 'Approved',
            Approved_By__c = UserInfo.getUserId(),
            Approved_At__c = System.now()
        );
        insert requisition;

        List<Job_Opening__c> openings = new List<Job_Opening__c>{
            new Job_Opening__c(
                Requisition__c = requisition.Id,
                Position__c = position.Id,
                Status__c = 'Published',
                Is_Published__c = true,
                Public_Job_Title__c = 'Visible Synthetic Role',
                Public_Description__c = 'Public synthetic description.',
                Publication_Date__c = Date.today(),
                Application_Deadline__c = Date.today().addDays(10),
                Number_of_Openings__c = 1,
                Number_Filled__c = 0
            ),
            new Job_Opening__c(
                Requisition__c = requisition.Id,
                Position__c = position.Id,
                Status__c = 'On Hold',
                Is_Published__c = true,
                Public_Job_Title__c = 'Hidden On Hold Role',
                Public_Description__c = 'Must not be returned.',
                Publication_Date__c = Date.today(),
                Application_Deadline__c = Date.today().addDays(10),
                Number_of_Openings__c = 1,
                Number_Filled__c = 0
            ),
            new Job_Opening__c(
                Requisition__c = requisition.Id,
                Position__c = position.Id,
                Status__c = 'Published',
                Is_Published__c = true,
                Public_Job_Title__c = 'Hidden Expired Role',
                Public_Description__c = 'Must not be returned.',
                Publication_Date__c = Date.today().addDays(-10),
                Application_Deadline__c = Date.today().addDays(-1),
                Number_of_Openings__c = 1,
                Number_Filled__c = 0
            )
        };
        insert openings;

        insert new List<Job_Application__c>{
            new Job_Application__c(
                Candidate__c = candidates[0].Id,
                Job_Opening__c = openings[0].Id,
                Status__c = 'Draft'
            ),
            new Job_Application__c(
                Candidate__c = candidates[1].Id,
                Job_Opening__c = openings[0].Id,
                Status__c = 'Draft'
            )
        };
        }
    }

    @IsTest
    static void derivesCandidateAndRejectsCrossCandidateApplication() {
        User candidateAUser = [
            SELECT Id FROM User WHERE LastName = 'Portal Candidate A' LIMIT 1
        ];
        Contact contactA = [
            SELECT Id FROM Contact WHERE Email = 'jordan.step9@example.invalid' LIMIT 1
        ];
        Map<String, Candidate__c> candidatesByEmail = new Map<String, Candidate__c>();
        for (Candidate__c candidate : [
            SELECT Id, Email__c FROM Candidate__c
            WHERE Email__c IN (
                'jordan.step9@example.invalid',
                'morgan.step9@example.invalid'
            )
        ]) {
            candidatesByEmail.put(candidate.Email__c, candidate);
        }
        Job_Application__c candidateBApplication = [
            SELECT Id FROM Job_Application__c
            WHERE Candidate__c = :candidatesByEmail.get(
                'morgan.step9@example.invalid'
            ).Id
            LIMIT 1
        ];

        System.runAs(candidateAUser) {
            RTPCandidateContext.contactIdOverride = contactA.Id;
            RTPPortalCandidateController.CandidateProfile profile =
                RTPPortalCandidateController.getMyProfile();
            System.assertEquals(
                candidatesByEmail.get('jordan.step9@example.invalid').Id,
                profile.id
            );

            List<RTPPortalCandidateController.ApplicationSummary> applications =
                RTPPortalCandidateController.getMyApplications();
            System.assertEquals(1, applications.size());

            Boolean denied = false;
            try {
                RTPPortalCandidateController.getMyApplication(
                    candidateBApplication.Id
                );
            } catch (AuraHandledException expected) {
                denied = true;
                System.assertEquals(
                    'The application is not available.',
                    expected.getMessage()
                );
                System.assertEquals(
                    false,
                    expected.getMessage().contains(
                        String.valueOf(candidateBApplication.Id)
                    )
                );
            }
            System.assert(denied, 'Cross-candidate access must be rejected.');
            RTPCandidateContext.contactIdOverride = null;
        }
    }

    @IsTest
    static void returnsOnlyPortalVisibleJobsAndSafeFields() {
        User candidateAUser = [
            SELECT Id FROM User WHERE LastName = 'Portal Candidate A' LIMIT 1
        ];
        System.runAs(candidateAUser) {
            List<RTPPortalJobController.JobCard> jobs =
                RTPPortalJobController.getPublishedJobs();
            System.assertEquals(1, jobs.size());
            System.assertEquals('Visible Synthetic Role', jobs[0].title);

            String serializedResult = JSON.serialize(jobs);
            System.assertEquals(false, serializedResult.contains('Status__c'));
            System.assertEquals(false, serializedResult.contains('Assigned_Recruiter'));
            System.assertEquals(false, serializedResult.contains('Requirements_Version'));
        }
    }

    @IsTest
    static void returnsControlledJobListingError() {
        User candidateAUser = [
            SELECT Id FROM User WHERE LastName = 'Portal Candidate A' LIMIT 1
        ];
        System.runAs(candidateAUser) {
            RTPPortalJobController.forceControlledError = true;
            Boolean controlled = false;
            try {
                RTPPortalJobController.getPublishedJobs();
            } catch (AuraHandledException expected) {
                controlled = true;
                System.assertEquals(
                    'Published jobs are temporarily unavailable.',
                    expected.getMessage()
                );
            }
            System.assert(controlled, 'Job listing failures must return a controlled error.');
        }
    }

    @IsTest
    static void returnsControlledErrorWithoutCandidateIdentity() {
        User candidateBUser = [
            SELECT Id FROM User WHERE LastName = 'Portal Candidate B' LIMIT 1
        ];
        System.runAs(candidateBUser) {
            RTPCandidateContext.contactIdOverride = null;
            Boolean controlled = false;
            try {
                RTPPortalCandidateController.getMyProfile();
            } catch (AuraHandledException expected) {
                controlled = true;
                System.assertEquals(
                    'Your candidate profile is unavailable.',
                    expected.getMessage()
                );
            }
            System.assert(controlled, 'Missing identity must return a controlled error.');
        }
    }
}
