$('#flash .close').live 'click', (event) ->
  p = $(this).parent()
  p.slideUp 'fast', -> p.remove()