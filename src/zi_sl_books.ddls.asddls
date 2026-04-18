@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Books Value Help'
define view entity ZI_SL_BOOKS as select from zsl_books {
  
  @UI.lineItem: [{ position: 10 }]
  key book_id as BookId,
  
  @UI.lineItem: [{ position: 20 }]
  title as Title,
  
  @UI.lineItem: [{ position: 30 }]
  status as Status
}
