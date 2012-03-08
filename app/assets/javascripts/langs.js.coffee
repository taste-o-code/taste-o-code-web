@Styx.Initializers.Languages =

  show: (data) ->
    $ ->
      CODE_MIRROR_THEME_COOKIE = 'cm-theme'
      theme = $.cookie(CODE_MIRROR_THEME_COOKIE) ? 'default'
      CodeMirror(
        $('#code_example')[0],
        {
          mode: data.syntax_mode || 'text/plain',
          theme: theme,
          readOnly: true,
          value: data.code
        }
      )

