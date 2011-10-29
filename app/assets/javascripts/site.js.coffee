$('#flash .close').live 'click', (event) ->
  p = $(this).parent()
  p.slideUp 'fast', -> p.remove()

$('#user_bar.logged-in').live 'hover', (event) ->
  if event.type == 'mouseenter'
    $(this).find('ul').show()
  else
    $(this).find('ul').hide()