@Styx.Initializers.Home =
  show: -> $ ->
    $('.language').on 'click', (event) ->
      window.location = Routes.language_path(this.id) unless $(event.target).hasClass('buy')

    showDialog = (dialog) ->
      dialog_top = $(window).height() / 2 + dialog.height()
      dialog.css {top: dialog_top}
      dialog.reveal {animation: 'fade', closeOnBackgroundClick: false}


    $('#non_purchased_langs .buy').on 'click', ->
      lang = $(this).parent('.language')
      $('#lang_name').html lang.find('.name').html()
      $('#lang_price').html lang.find('.price').html()
      $('#buy_form #lang_id').val lang.attr('id')
      showDialog $('#buy_dialog')

    $('#buy_button').on 'click', ->
      $(this).trigger 'reveal:close'
      $('#buy_form').submit()

    $('#cancel_button').on 'click', ->
      $(this).trigger 'reveal:close'

    moveLanguage = (lang, tasksCount) ->
      duration = 1000
      lang.fadeOut duration, ->
        $('#purchased_langs').prepend lang
        lang.find(el).remove() for el in ['.price', '.buy']
        scores = $('<div/>')
          .addClass('score middle')
          .append($('<p/>').addClass('solved').text('0'))
          .append($('<p/>').addClass('unsolved').text('/ ' + tasksCount))
        progress = $('<div/>')
          .addClass('progress')
          .append($('<p/>').addClass('solved').css('width', '0%'))
        lang.append(scores).append progress
        lang.fadeIn duration

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
        window.alert """You can't buy this language.\n
                      May be we can't connect to server :|\n
                      or you're out of points :(\n
                      or you've already bought this language o_O\n
                      or you're trying to break the system! >:O"""

  greeting: (data) -> $ ->
    # Replace all <pre><code>...</code></pre> blocks with CodeMirror.
    $('pre code').each ->
      el = $(this)
      parent = el.parents('.lang')[0]
      mode = el.attr('class') || CodeMirror.DEFAULT_SYNTAX_MODE
      CodeMirror(
        parent,
        {
          mode: mode,
          theme: 'default',
          readOnly: true,
          lineWrapping: true,
          value: el.text()
        }
      )
      el.parent().remove()

