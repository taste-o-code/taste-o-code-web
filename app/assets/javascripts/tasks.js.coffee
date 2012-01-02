$ ->

  CHECK_INTERVAL = 5000

  $('.task-page #submit_button').on 'click', ->
    if $('#source').val().length == 0
      window.alert("You cannot submit empty solution")
      return
    $('#submit_form').submit()
    $('#source').val('')


  updateSubmissionsByResponse = (submissions) ->
    $(submissions).each (ind, submission) ->
      return if submission.result == 'testing'
      div = $('#' + submission.id)
      div.removeAttr('data-testing')
      image = '/assets/' + submission.result + '.png'
      div.find('.result img').attr('src', image)

  checkSubmissions = ->
    ids = $('.submission[data-testing="true"]').map( -> this.id ).toArray()
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


  $('.task-page #submit_form').on 'ajax:success', (evt, data) ->
    submission = $('<div/>')
      .addClass('submission')
      .attr('id', data.submission_id)
      .attr('data-testing', 'true')
      .append($('<div/>')
        .addClass('time')
        .text(data.time))
      .append($('<div/>')
        .addClass('source')
        .text('#'))
      .append($('<div/>')
        .addClass('result')
        .append($('<img/>')
          .attr('src', '/assets/testing.gif')
          .attr('alt', 'Testing')))
    $('#submission_header').after submission
