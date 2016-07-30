 $(document).on "page:change", ->
    $('#new-drink-link').click (event) ->
      event.preventDefault()
      alert "clicked !"