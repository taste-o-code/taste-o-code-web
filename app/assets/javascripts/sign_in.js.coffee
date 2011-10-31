$('.google').live 'click', (event) ->
  $('#user_identity_url').val('https://www.google.com/accounts/o8/id')
  $('#openid_form').submit()

