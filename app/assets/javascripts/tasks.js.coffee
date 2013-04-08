@Styx.Initializers.Tasks =

  show: (data) ->
    $ ->
      CHECK_INTERVAL = 3000

      storeTheme = (theme) -> $.cookie CodeMirror.COOKIE, theme, { path: '/', expires: 30 }

      themeSelector = $('.cm-theme-selector select')
      themeSelector.append $('<option>').val(theme).text(theme) for theme in CodeMirror.THEMES

      theme = $.cookie(CodeMirror.COOKIE) ? 'default'

      storeTheme theme
      themeSelector.val theme

      editors = []
      createCodeMirror = (textArea) ->
        editor = CodeMirror.fromTextArea(
          textArea,
          {
            mode: data.syntax_mode || CodeMirror.DEFAULT_SYNTAX_MODE,
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
      $('.description pre code').each (_, el) ->
        el = $(el)
        textarea = $('<textarea/>').val(el.text())
        el.parent().replaceWith textarea
        editor = createCodeMirror textarea[0]
        editor.setOption 'readOnly', true
        editor.setOption 'lineNumbers', false

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
          TOC.warning 'Empty solution', "Your can't submit empty solution."

      # Show submission source
      $('#submissions').on 'click', '.source img', (e) ->
        sourceIcon = $(e.currentTarget)
        sourceIcon.attr { src: '/assets/loader.gif' }
        $.ajax {
          url: Routes.source_submission_path(sourceIcon.closest('tr').data('submissionId')),
          success: (data) ->
            window.submissionSourceViewer.setValue data.source
            $('#submission_source').reveal { animation: 'none' }
            sourceIcon.attr src: '/assets/source.png'
        }

      setCheckSubmissionsTimer = -> window.setTimeout checkSubmissions, CHECK_INTERVAL

      shorten = (message) ->
        if message.length > 50
          message[0..50] + "...\n\tSee more details in submissions table."
        else
          message

      updateSubmissionsByResponse = (response) ->
        $(response.submissions).each (ind, submission) ->
          return if submission.result == 'testing'

          submissionBlock = $('#submissions [data-submission-id="' + submission.id + '"]').removeAttr('data-testing')
          title = if submission.result == 'accepted' then 'Accepted' else submission.fail_cause
          submissionBlock.find('.result img')
            .attr('src', '/assets/' + submission.result + '.png')
            .attr('title', title)
            .attr('alt', title)

          message = if submission.result == 'accepted' then 'Solution has been accepted.' else submission.fail_cause
          TOC.notify submission.result, shorten(message), submission.result

        TOC.availablePoints response.available_points
        TOC.totalPoints response.total_points

      checkSubmissions = ->
        ids = $('#submissions [data-testing="true"]').map(-> $(this).data('submissionId')).toArray()
        if ids.length > 0
          $.ajax {
            url: Routes.submissions_path(),
            data: { ids: ids },
            success: updateSubmissionsByResponse
            complete: setCheckSubmissionsTimer
          }
        else
          setCheckSubmissionsTimer()

      setCheckSubmissionsTimer()

      $('#submit_form').on 'ajax:success', ->
        $.ajax {
          url: Routes.submissions_language_task_path(data.language, data.task, {format: 'js'}),
          data: { page: $('#pagination .current').text().trim() },
        }

      # remove anchor behavior from comments/submissions tabs
      $('dl.tabs').each ->
        $(this).children('dd').children('a').click (e) -> e.preventDefault()

      comment_form = $('#comment_form')

      comment_form.find('button').on 'click', ->
        if comment_form.find('#body').val().trim().length > 0
          form = comment_form.find('form')
          $.post form.attr('action'), form.serialize(), (data) ->
            if data.comment
              form.find('#body').val('')
              list = $('#comments ul')
              if list.length == 0
                $('#comments .no-content').remove()
                list = $('<ul>', { class: 'comments' }).prependTo('#comments')
              list.append data.comment
            else
              TOC.error 'Error', data.error
        else
          TOC.warning 'Empty comment', "Your can't submit empty comment."
