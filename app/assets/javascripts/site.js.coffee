# Flash notification close button
$('#flash .close').live 'click', (event) ->
  p = $(this).parent()
  p.slideUp 'fast', -> p.remove()


# Header drop-downs (login form, user menu)
$('#header .dropdown-trigger.hover-trigger').live 'hover', (event) ->
  $(this).find('.header-dropdown')[if event.type == 'mouseenter' then 'show' else 'hide']()

$('#header .dropdown-trigger.click-trigger').live('click', (event) ->
  if event.target == this then $(this).toggleClass 'opened'
  event.stopPropagation()
)

$('body').live 'click', (event) -> $('#header .dropdown-trigger.click-trigger').removeClass('opened')


# Login form response handler
$('form#login_form').live 'ajax:success', (evt, data, status, xhr) ->
  $(this).siblings('.alert-box').remove()
  if data.success
    $(this).parent().html $('<div/>', { class: 'alert-box success', }).html(data.message)
    setTimeout (-> window.location.reload()), 1000
  else
    $('<div/>', { class: 'alert-box error', }).html(data.message).insertBefore this
