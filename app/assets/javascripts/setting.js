$(document).ready(function() {
  setTimeout(function() {$('.time-out').hide('slow');}, 3000);
});

$(document).on('click', '.close', function () {$(this).parent().hide();});

/**
 *  Show notification
 * 
 *  id: is id off element. No duplicate
 * 
 *  type: type of notify
 * 
 *  0: alert-info, 1: alert-success, 2: alert-warning, 3: alert-danger
 * 
 *  message: you don't know ??
 * */
function show_notify(id, type, message) {
  var lst_type = ['alert-info', 'alert-success', 'alert-warning', 'alert-danger']
  $('.my-notify').append('<div id="' + id +'" class="alert ' + lst_type[parseInt(type)] + '\
    notify2 pointer-add"><button type="button" class="close">×</button>\
    <p class="line-clamp">' + message + '</p></div>');
  var div_notify = $('#'+id);
  div_notify.delay(0).fadeIn('slow');
  div_notify.delay(3000).fadeOut('slow', function() {$(this).remove();});
}
