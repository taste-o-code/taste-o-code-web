$('#nav a').live 'click', (event) ->
  $('#nav .active').removeClass 'active'
  $(this).addClass 'active'
  true