$ ->
  $('.language').on 'click', (event) ->
    return if $(event.target).hasClass 'buy'
    url = '/languages/' + this.id;
    window.location = url

  $('#non_purchased_langs .buy').on 'click', ->
    lang = $(this).parent('.language')
    $('#language_to_buy').html lang.find('.name').html()
    $('#price').html lang.find('.price').html()
    $('#buy_form #id').val lang.attr('id')
    $('#buy_dialog').reveal({animation: 'fade'})

  $('#buy_button').on 'click', ->
    $(this).trigger 'reveal:close'
    $('#buy_form').submit()

  $('#cancel_button').on 'click', ->
    $(this).trigger 'reveal:close'

  moveLanguage = (lang, tasksCount) ->
    lang.slideUp 'slow', ->
      $('#purchased_langs').prepend lang
      lang.find(el).remove() for el in ['.price', '.buy']
      scores = $('<div/>')
        .addClass('score middle')
        .append($('<p/>').addClass('solved').text('0'))
        .append($('<p/>').addClass('unsolved').text('/ ' + tasksCount))
      progress = $('<div/>')
        .addClass('progress')
        .append($('<p/>').addClass('solved').css('width', '0%'))
      lang.append(scores).append(progress)
      lang.slideDown('slow')

  removeBuyButtons = (availablePoints) ->
    $('#non_purchased_langs .language')
      .filter( -> $(this).attr('data-price') > availablePoints )
      .find('.buy').remove()

  $('#buy_form').on 'ajax:success', (evt, data) ->
    if data.success
      lang = $('#' + data.lang)
      $('#points').text data.available_points
      moveLanguage lang, data.tasks_count
      removeBuyButtons data.available_points
    else
      window.alert 'No :('

