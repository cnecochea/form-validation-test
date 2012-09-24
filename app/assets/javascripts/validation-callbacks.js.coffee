currentErrors = {}
clientSideValidations.callbacks.element.fail = (element, message, addError, eventData) ->
  addError()
  name = element.attr('name')
  labelText = $("label:not([class='message'])[for='#{element.attr('id')}']").text()
  currentErrors[labelText || name] = message
  
clientSideValidations.callbacks.form.fail = (form, eventData) ->
  err = if $('ul.errors').length then $('ul.error') else $('<ul class="errors"></ul>')
  err.html('')
  for field, message of currentErrors
    err.append("<li>#{field}  #{message}</li>")
  form.prepend(err)
