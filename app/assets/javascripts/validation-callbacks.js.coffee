currentErrors = {}

printErrors = (form) ->
  err = if $('ul.errors').length then $('ul.errors') else $('<ul class="errors validation-rollup" role="alert"></ul>')
  err.html('')
  for field, data of currentErrors
    err.append("<li>#{field} #{data.message} <a href=\"##{data.anchor}\" onclick=\"$('\##{data.anchor}').focus(); return false\">Fix me!</a></li>")
  form.prepend(err)

clientSideValidations.callbacks.element.pass = (element, removeError, eventData) ->
  id = element.attr('id')
  labelText = $("label:not([class='message'])[for='#{id}']").text()
  delete currentErrors[labelText || name]
  printErrors element.closest('form')
  removeError()

clientSideValidations.callbacks.element.fail = (element, message, addError, eventData) ->
  addError()
  id = element.attr('id')
  labelText = $("label:not([class='message'])[for='#{id}']").text()
  anchor = if element.attr('type') == 'hidden' then $("[id*=#{id}]").attr('id') else element.attr('id')
  currentErrors[labelText || name] = {message: message, anchor: anchor}
  printErrors element.closest('form')
  
clientSideValidations.callbacks.form.fail = (form, eventData) ->
  printErrors(form)

writeValueToHiddenField = (el, val) ->
  targetId = $(el).data 'validated-by'
  target = $("##{targetId}")
  target.val val
  target.data 'changed', true
  target.trigger 'focusout'

buildDateString = (dateFieldId) ->
  year = [1,2,3].map (i, n) ->
    parseInt($("##{dateFieldId}_#{i}i").val()) || 0
  hiddenDate = ""
  yearTotal = 1
  yearTotal *= y for y in year
  if yearTotal > 0
    hiddenDate = year.join('-')
  hiddenDate

validateHiddenField = (e) ->
  target = $(e.target)
  if target.data('pre-validation-callback')
    val = eval target.data('pre-validation-callback')
  else
    val = e.target.value
  writeValueToHiddenField e.target, val

$ ->
  $(document).on 'blur', 'form[data-validate=true] input[data-validated-by]', (e) ->
    validateHiddenField(e)

  $(document).on 'change', 'form[data-validate=true] select[data-validated-by]', (e) ->
    validateHiddenField(e)

