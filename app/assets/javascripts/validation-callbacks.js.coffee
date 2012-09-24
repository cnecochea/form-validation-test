currentErrors = {}
clientSideValidations.callbacks.element.fail = (element, message, addError, eventData) ->
  addError()
  id = element.attr('id')
  labelText = $("label:not([class='message'])[for='#{id}']").text()
  currentErrors[labelText || name] = {message: message, anchor: id}
  
clientSideValidations.callbacks.form.fail = (form, eventData) ->
  err = if $('ul.errors').length then $('ul.error') else $('<ul class="errors"></ul>')
  err.html('')
  for field, data of currentErrors
    err.append("<li>#{field} #{data.message} <a href=\"##{data.anchor}\" onclick=\"$('\##{data.anchor}').focus()\">Fix me!</a></li>")
  form.prepend(err)
