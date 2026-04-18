@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Smart Library Checkouts'
@Metadata.allowExtensions: true
define root view entity ZI_SL_CHECKOUTS as select from zsl_checkouts {
  key trans_id as TransId,
  
@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SL_BOOKS', element: 'BookId' } }]
  book_id as BookId,
  
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SL_MEMBERS', element: 'MemberId' } }]
  member_id as MemberId,
  
  checkout_date as CheckoutDate,
  due_date as DueDate,
  return_date as ReturnDate,
  fine_amount as FineAmount,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
