@Styx.Initializers.Tasks =

  show: (data) ->
    $ ->
      CHECK_INTERVAL = 3000

      CODE_MIRROR_THEMES = ['default', 'cobalt', 'eclipse', 'elegant', 'monokai', 'neat', 'night', 'rubyblue']

      CODE_MIRROR_THEME_COOKIE = 'cm-theme'

      storeTheme = (theme) -> $.cookie CODE_MIRROR_THEME_COOKIE, theme, { path: '/', expires: 30 }

      themeSelector = $('.cm-theme-selector select')
      themeSelector.append $('<option>').val(theme).text(theme) for theme in CODE_MIRROR_THEMES

      theme = $.cookie(CODE_MIRROR_THEME_COOKIE) ? 'default'

      storeTheme theme
      themeSelector.val theme

      editors = []
      createCodeMirror = (textArea) ->
        editor = CodeMirror.fromTextArea(
          textArea,
          {
            mode: data.syntax_mode || 'text/plain',
            theme: theme,
            lineNumbers: true
          }
        )
        editors.push editor
        editor

      window.sourceEditor = createCodeMirror $('#source')[0]
      window.submissionSourceViewer = createCodeMirror $('#submission_source textarea')[0]
      window.submissionSourceViewer.setOption 'readOnly', true
      window.submissionSourceViewer.setOption 'lineWrapping', true


      # Replace all <pre><code>...</code></pre> blocks with CodeMirror.
      $('.description pre code').each((_, el) ->
        el = $(el)
        textarea = $('<textarea/>').val(el.text())
        el.parent().replaceWith textarea
        editor = createCodeMirror textarea[0]
        editor.setOption 'readOnly', true
        editor.setOption 'lineNumbers', false
      )

      themeSelector.change ->
        theme = $(this).val()
        storeTheme theme
        changeTheme = (editor) -> editor.setOption 'theme', theme
        changeTheme editor for editor in editors

      $('#source_container').css visibility: 'visible'

      $('#submit_button').on 'click', ->
        window.sourceEditor.save()
        if $('#source').val().length > 0
          $('#submit_form').submit()
        else
          $.gritter.add {image: '/assets/warning.png', title: 'Empty solution', text: 'Your can\'t submit empty solution.'}

      # Show submission source
      $('#submissions').on 'click', '.source img', (evt) ->
        id = $(evt.currentTarget).parents('.submission').attr('id')
        evt.currentTarget.src = '/assets/testing.gif'
        $.ajax {
          url: '/get_submission_source',
          data: {id: id},
          success: (data) ->
            window.submissionSourceViewer.setValue data.source
            $('#submission_source').reveal {animation: 'none'}
            evt.currentTarget.src = '/assets/source.png'
        }

      setCheckSubmissionsTimer = -> window.setTimeout checkSubmissions, CHECK_INTERVAL

      updateSubmissionsByResponse = (submissions) ->
        $(submissions).each (ind, submission) ->
          result = submission.result
          return if result == 'testing'
          div = $('#' + submission.id)
          div.removeAttr('data-testing')
          image = '/assets/' + result + '.png'
          div.find('.result img').attr('src', image)
          title = result.substr(0, 1).toUpperCase() + result.substr(1)
          message = if result == 'accepted' then 'Solution has been accepted.' else submission.fail_cause
          $.gritter.add { image: image, title: title, text: message }

      checkSubmissions = ->
        ids = $('.submission[data-testing="true"]').map(-> this.id).toArray()
        if ids.length > 0
          $.ajax {
            url: '/check_submissions',
            data: { ids: ids },
            success: (data) -> updateSubmissionsByResponse(data)
            complete: setCheckSubmissionsTimer
          }
        else
          setCheckSubmissionsTimer()

      setCheckSubmissionsTimer()

      $('#submit_form').on 'ajax:success', (evt, data) ->
        current_page = $('#pagination .current').text().trim()
        # Refresh div with submissions.
        $.ajax {
          url: window.location.href,
          data: { page: current_page },
          beforeSend: (xhr, settings) -> xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script)
        }
