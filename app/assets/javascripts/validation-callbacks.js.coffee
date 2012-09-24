$ ->
  $(document).on 'change', '.validated-datefield', (e) ->
    dateFieldId = e.target.id.replace(/_\di$/, "")
    year = [1,2,3].map (i, n) ->
      parseInt($("##{dateFieldId}_#{i}i").val()) || 0

    hiddenDate = ""
    yearTotal = 1
    yearTotal *= y for y in year
    if yearTotal > 0
      hiddenDate = year.join('-')

    elem = $("input##{dateFieldId}")
    elem.val(hiddenDate)
    elem.data('changed', true)
    elem.trigger('focusout')

currentErrors = {}

printErrors = (form) ->
  err = if $('ul.errors').length then $('ul.errors') else $('<ul class="errors"></ul>')
  err.html('')
  for field, data of currentErrors
    err.append("<li>#{field} #{data.message} <a href=\"##{data.anchor}\" onclick=\"$('\##{data.anchor}').focus()\">Fix me!</a></li>")
  form.prepend(err)

clientSideValidations.callbacks.element.pass = (element, callback, eventData) ->
  id = element.attr('id')
  labelText = $("label:not([class='message'])[for='#{id}']").text()
  delete currentErrors[labelText || name]
  printErrors element.closest('form')
  callback()

clientSideValidations.callbacks.element.fail = (element, message, addError, eventData) ->
  addError()
  id = element.attr('id')
  labelText = $("label:not([class='message'])[for='#{id}']").text()
  anchor = if element.attr('type') == 'hidden' then $("[id*=#{id}]").attr('id') else element.attr('id')
  currentErrors[labelText || name] = {message: message, anchor: anchor}
  printErrors element.closest('form')
  
clientSideValidations.callbacks.form.fail = (form, eventData) ->
  printErrors(form)

