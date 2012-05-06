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
  $(this).parent().html $('<div/>', { class: 'alert-box success', }).html(data.message)
  setTimeout (-> window.location.reload()), 1000


$('form#login_form').live 'ajax:error', (xhr, status, error) ->
  $(this).siblings('.alert-box').remove()
  error = $.parseJSON(status.responseText).error
  $('<div/>', { class: 'alert-box error' }).html(error).insertBefore this


CodeMirror.THEMES = ['default', 'cobalt', 'eclipse', 'elegant', 'monokai', 'neat', 'night', 'rubyblue']
CodeMirror.COOKIE = 'cm-theme'
CodeMirror.DEFAULT_SYNTAX_MODE = 'text/plain'


# Global Taste-O-Code object hosting utility functions
window.TOC =
  NOTIFICATIONS: ['success', 'notice', 'warning', 'error']

  notify: (title, message, notificationType) ->
    $.gritter.add {
      image: '/assets/' + notificationType + '.png',
      title: this.capitalize(title),
      text:  this.capitalize(message)
    }

  capitalize: (string) ->
    string.substr(0, 1).toUpperCase() + string.substr(1)

  points: (points) ->
    $('#user_bar .points').text points

# Define notification functions like TOC.alert('Title', 'Message')
for notification in TOC.NOTIFICATIONS
  do (notification) ->
    TOC[notification] = (title, message) -> TOC.notify title, message, notification