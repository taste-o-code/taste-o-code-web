@Styx.Initializers.Languages =

  show: (data) ->
    $ ->
      codeExample = $('#code_example')
      if (codeExample.length > 0)
        code = $(codeExample).find('pre code')
        code.parent().remove()
        text = code.text()
        mode = code.attr('class') || CodeMirror.DEFAULT_SYNTAX_MODE
        CodeMirror(
          codeExample[0],
          {
            mode: mode,
            theme: $.cookie(CodeMirror.COOKIE) ? 'default',
            readOnly: true,
            value: text
          }
        )
