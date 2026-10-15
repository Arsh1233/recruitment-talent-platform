// Add users already identified by assignments or permission sets to the
// corresponding internal sharing groups. This script never guesses committee
// membership and never removes manually approved members.
Map<String, Group> groupsByName = new Map<String, Group>();
for (Group groupRecord : [
    SELECT Id, DeveloperName
    FROM Group
    WHERE Type = 'Regular'
    AND DeveloperName IN ('RTP_All_Recruiters', 'RTP_Succession_Committee')
]) {
    groupsByName.put(groupRecord.DeveloperName, groupRecord);
}

Set<Id> recruiterIds = new Set<Id>();
for (Job_Requisition__c recordItem : [
    SELECT Assigned_Recruiter__c FROM Job_Requisition__c
    WHERE Assigned_Recruiter__c != null
]) {
    recruiterIds.add(recordItem.Assigned_Recruiter__c);
}
for (Job_Opening__c recordItem : [
    SELECT Assigned_Recruiter__c FROM Job_Opening__c
    WHERE Assigned_Recruiter__c != null
]) {
    recruiterIds.add(recordItem.Assigned_Recruiter__c);
}
for (Job_Application__c recordItem : [
    SELECT Assigned_Recruiter__c FROM Job_Application__c
    WHERE Assigned_Recruiter__c != null
]) {
    recruiterIds.add(recordItem.Assigned_Recruiter__c);
}

Set<Id> successionUserIds = new Set<Id>();
for (PermissionSetAssignment assignment : [
    SELECT AssigneeId
    FROM PermissionSetAssignment
    WHERE PermissionSet.Name = 'RTP_Succession_Access'
]) {
    successionUserIds.add(assignment.AssigneeId);
}

Map<Id, Set<Id>> desiredMembersByGroup = new Map<Id, Set<Id>>();
desiredMembersByGroup.put(groupsByName.get('RTP_All_Recruiters').Id, recruiterIds);
desiredMembersByGroup.put(groupsByName.get('RTP_Succession_Committee').Id, successionUserIds);

Set<String> existingMemberships = new Set<String>();
for (GroupMember membership : [
    SELECT GroupId, UserOrGroupId
    FROM GroupMember
    WHERE GroupId IN :desiredMembersByGroup.keySet()
]) {
    existingMemberships.add(membership.GroupId + '|' + membership.UserOrGroupId);
}

List<GroupMember> membershipsToAdd = new List<GroupMember>();
for (Id groupId : desiredMembersByGroup.keySet()) {
    for (Id userId : desiredMembersByGroup.get(groupId)) {
        String membershipKey = groupId + '|' + userId;
        if (!existingMemberships.contains(membershipKey)) {
            membershipsToAdd.add(new GroupMember(GroupId = groupId, UserOrGroupId = userId));
        }
    }
}
if (!membershipsToAdd.isEmpty()) {
    insert membershipsToAdd;
}

System.debug(
    LoggingLevel.INFO,
    'RTP_GROUP_MEMBER_SYNC=SUCCESS added=' + membershipsToAdd.size()
);
