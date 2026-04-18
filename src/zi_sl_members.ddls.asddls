@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Members Value Help'
define view entity ZI_SL_MEMBERS as select from zsl_members {
  
  @UI.lineItem: [{ position: 10 }]
  key member_id as MemberId,
  
  @UI.lineItem: [{ position: 20 }]
  name as Name
}
