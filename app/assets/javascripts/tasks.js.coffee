@Styx.Initializers.Tasks =

  show: (data) ->
    $ ->
      CHECK_INTERVAL = 5000

      window.sourceEditor = CodeMirror.fromTextArea(
        document.getElementById('source'),
        {
          mode: data.cm_mode || 'text/plain',
          theme: 'cobalt',
          lineNumbers: true
        }
      )

      $('#source_container').css visibility: 'visible'

      $('#submit_button').on 'click', ->
        window.sourceEditor.save()
        if $('#source').val().length > 0
          $('#submit_form').submit()
        else
          $.gritter.add {image: '/assets/warning.png', title: 'Empty solution', text: 'Your can\'t submit empty solution.'}

      updateSubmissionsByResponse = (submissions) ->
        $(submissions).each (ind, submission) ->
          result = submission.result
          return if result == 'testing'
          div = $('#' + submission.id)
          div.removeAttr('data-testing')
          image = '/assets/' + result + '.png'
          div.find('.result img').attr('src', image)
          title = result.substr(0, 1).toUpperCase() + result.substr(1)
          message = if result == 'accepted' then 'Solution has been accepted.' else 'Solution has failed.'
          $.gritter.add {image: image, title: title, text: message}

      checkSubmissions = ->
        ids = $('.submission[data-testing="true"]').map(-> this.id).toArray()
        if ids.length == 0
          window.setTimeout checkSubmissions, CHECK_INTERVAL
        else
          $.ajax {
            url: '/check_submissions',
            data: {ids: ids},
            success: (data) ->
              updateSubmissionsByResponse data
            complete: ->
              window.setTimeout checkSubmissions, CHECK_INTERVAL
          }

      window.setTimeout checkSubmissions, CHECK_INTERVAL

      $('#submit_form').on 'ajax:success', (evt, data) ->
        current_page = $('#pagination .current').text().trim()
        # Refresh div with submissions.
        $.ajax {
          url: window.location.href,
          data: {page: current_page},
          beforeSend: (xhr, settings) ->
            xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script)
        }
