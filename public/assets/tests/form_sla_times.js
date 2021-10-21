test("form SLA times highlights first row and sets 2:00 by default for new item", function(assert) {
  $('#forms').append('<hr><h1>SLA with defaults</h1><form id="form1"></form>')

  var el = $('#form1')

  var item = new App.Sla()

  new App.ControllerForm({
    el:     el,
    model:  item.constructor,
    params: item
  });

  var row = el.find('.sla_times tbody > tr:first')

  ok(row.hasClass('is-active'))
  equal(row.find('input[data-name=first_response_time]').val(), '02:00')

  $('#forms').append('<hr><h1>SLA with empty times</h1><form id="form2"></form>')

  var el = $('#form2')

  var item = new App.Sla()
  item.id = '123'

  new App.ControllerForm({
    el:     el,
    model:  item.constructor,
    params: item
  });

  var row = el.find('.sla_times tbody > tr:first')

  notOk(row.hasClass('is-active'))
  equal(row.find('input[data-name=first_response_time]').val(), '')
});

test("form SLA times highlights and shows settings accordingly", function(assert) {
  $('#forms').append('<hr><h1>SLA with non-first time set</h1><form id="form3"></form>')

  var el = $('#form3')

  var item = new App.Sla()
  item.id = '123'
  item.update_time = 240

  new App.ControllerForm({
    el:     el,
    model:  item.constructor,
    params: item
  });

  var firstRow = el.find('.sla_times tbody > tr:first')
  var secondRow = el.find('.sla_times tbody > tr:nth-child(2)')

  notOk(firstRow.hasClass('is-active'))
  equal(firstRow.find('input[data-name=first_response_time]').val(), '')
  ok(secondRow.hasClass('is-active'))
  equal(secondRow.find('input[data-name=update_time]').val(), '04:00')
})

test("form SLA times clears field instead of 00:00", function(assert) {
  $('#forms').append('<hr><h1>SLA placeholder instead of 00:00</h1><form id="form5"></form>')

  var el = $('#form5')

  var item = new App.Sla()

  new App.ControllerForm({
    el:     el,
    model:  item.constructor,
    params: item
  });

  var row = el.find('.sla_times tbody > tr:nth-child(2)')
  var input = row.find('input[data-name=update_time]')

  input.val('asd').blur()

  equal(input.val(), '', 'shows placeholder')
});
