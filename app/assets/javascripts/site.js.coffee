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
).live('hover', (event) ->
  if event.type == 'mouseleave'
    $(this).data 'timeout', setTimeout($.proxy((-> $(this).removeClass('opened')), this), 800)
  else
    clearTimeout $(this).data('timeout')
)

$('body').live 'click', (event) -> $('#header .dropdown-trigger.click-trigger').removeClass('opened')


# Login form response handler
$('form#login_form').live 'ajax:success', (evt, data, status, xhr) ->
  $(this).find('.loader').hide()
  $(this).find('input:submit').show()
  $('form#login_form .alert-box').remove()
  if data.success
    $('<div/>', { class: 'alert-box success', }).html(data.message).prependTo(this)
    setTimeout (-> window.location.href = data.redirect), 1000
  else
    $('<div/>', { class: 'alert-box error', }).html(data.message).prependTo(this)

$('form#login_form').live 'submit', (event) ->
  $(this).find('input:submit').hide()
  $(this).find('.loader').show()


# Processing placeholders for all inputs
$ ->
  $('textarea, input').placeholder()
