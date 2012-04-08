@Styx.Initializers.Languages =

  show: (data) ->
    $ ->
      codeExample = $('#code_example')
      if (data.code && codeExample.length > 0)
        CodeMirror(
          codeExample[0],
          {
            mode: data.syntax_mode || CodeMirror.DEFAULT_SYNTAX_MODE,
            theme: $.cookie(CodeMirror.COOKIE) ? 'default',
            readOnly: true,
            value: data.code
          }
        )
