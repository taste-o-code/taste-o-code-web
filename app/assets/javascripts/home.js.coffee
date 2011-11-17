# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#non_purchased_langs .language').on('click', (event) ->
    $('#language_to_buy').html $(this).find('.name').html()
    $('#price').html $(this).find('.price').html()
    $('#buy_form #id').val $(this).attr('id')
    $('#buy_dialog').reveal({animation: 'fade'}))

  $('#buy_button').on 'click', () ->
    $(this).trigger 'reveal:close'
    $('#buy_form').submit()

  $('#cancel_button').on 'click', () ->
    $(this).trigger 'reveal:close'

  $('#buy_form').on 'ajax:success', (evt, data, status, xhr) ->
    if data.success
      window.location.reload()
    else
      window.alert 'No :('

