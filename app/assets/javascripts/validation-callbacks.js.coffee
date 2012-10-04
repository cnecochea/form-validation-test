currentErrors = {}

printErrors = (form) ->
  err = if $('ol.errors').length then $('ol.errors') else $('<ol class="errors validation-rollup"></ol>')
  err.html('')
  idref = err.identify()
  for field, data of currentErrors
    err.append("<li>#{field} #{data.message} <a href=\"##{data.anchor}\" onclick=\"$('\##{data.anchor}').focus(); return false\">Fix me!</a></li>").attr
      tabindex: '0'
      role: 'alert'
      'aria-describedby': "title_#{idref}"
  form.append(err)
  $('.validation-rollup-title').remove()
  $('<p>Sorry, but we need a little more information to proceed.</p>')
    .addClass('validation-rollup-title')
    .insertBefore(err)
    .attr
      id: "title_#{idref}"
      role: 'heading'
      'aria-level': 2

  addAriaInvalidAttribute()

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
  target.trigger 'blur'

buildDateString = (dateFieldId) ->
  year = [1,2,3].map (i, n) ->
    parseInt($("##{dateFieldId}_#{i}i").val()) || 0
  hiddenDate = ""
  yearTotal = 1
  yearTotal *= y for y in year
  if yearTotal > 0
    hiddenDate = year.join('-')
  hiddenDate

atLeastOne = (elId) ->
  $("input[type=checkbox][id^=#{elId}]:checked").length

validateHiddenField = (e) ->
  target = $(e.target)
  if target.data('pre-validation-callback')
    val = eval target.data('pre-validation-callback')
  else
    val = e.target.value
  writeValueToHiddenField e.target, val

addAriaInvalidAttribute = ->
  $('.field_with_errors').children().filter(':input').attr('aria-invalid', true)

cleanUpRadioButtonErrors = ->
  err = (msg) ->
    $('<div/>').addClass('inline-error-message').text(msg)

  $('.radio-fields').each (index, field) ->
    if $(@).find('.field_with_errors').length > 1
      $(@).find('.field_with_errors').addClass('error-validation-patch')
        .find('.inline-error-message')
          .attr('aria-hidden', true)
          .hide()
      $(@).append(err($(@).find('.inline-error-message').eq(0).text())).wrapInner('<div class="field_with_errors" />')
      $(@).find('legend').prependTo($(@)) if $(@).find('legend').length > 0

addStar = (element) ->
  unless element.children(".required-indicator").length
    element.prepend  $('<abbr title="Required" class="required-indicator">*</abbr>')
 
addRequiredIndicators = ->
  $('form[data-validate="true"]').find('[data-validate="true"]').each (index, field) ->
    legend = $(@).closest('fieldset').find('legend')
    if legend.length > 0
      addStar legend.remove('.required-indicator')
    else
      addStar $('label[for=' + $(@).identify() + ']')
    $(@).prop('required', true).attr('aria-required', 'true')

anonymous_element_index = 0
$.fn.identify = ->
  el = @.first()
  anonymous_element_index += 1 while $("#anonymous_element_#{anonymous_element_index}").length
  el.attr('id', "anonymous_element_#{anonymous_element_index}") if !el.attr('id')
  el.attr('id')

$ ->
  $(document).on 'blur', 'form[data-validate=true] input[data-validated-by]', (e) ->
    validateHiddenField(e)

  $(document).on 'change', 'form[data-validate=true] select[data-validated-by]', (e) ->
    validateHiddenField(e)

  $(document).on 'click', 'form[data-validate=true] input[type=checkbox][data-validated-by]', (e) ->
    validateHiddenField(e)

  cleanUpRadioButtonErrors()

  addRequiredIndicators()

  addAriaInvalidAttribute()

