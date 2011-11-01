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
  $(this).find('.loader').hide()
  $('form#login_form .alert-box').remove()
  if data.success
    $('<div/>', { class: 'alert-box success', }).html(data.message).appendTo(this)
    setTimeout (-> window.location.href = data.redirect), 1000
  else
    $('<div/>', { class: 'alert-box error', }).html(data.message).prependTo(this)
    $(this).find('input:submit').show().removeAttr('disabled')

$('form#login_form').live 'submit', (event) ->
  $(this).find('input:submit').hide().attr('disabled', 'disabled')
  $(this).find('.loader').show()


# Processing placeholders for all inputs
$ ->
  $('textarea, input').placeholder()
