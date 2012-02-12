$ ->
  $('.language.formtastic  #add_link').on 'click', (event) ->
    event.preventDefault()
    $('<input/>')
      .attr('type','text')
      .attr('name', 'language[links][]')
      .insertBefore(this)
    $('<button/>')
      .addClass('delete_link')
      .text('Delete')
      .insertBefore(this)

  $('.language.formtastic  div.links').on 'click', '.delete_link',(event) ->
    event.preventDefault()
    $(this).prev().remove()
    $(this).remove()