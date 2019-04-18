$(document).ready(function() {
  if($('#markdown').length == 1){
    var simplemde = new SimpleMDE({
      element: document.getElementById("markdown")
    });
  
    simplemde.codemirror.on('refresh', function() {
      if (simplemde.isFullscreenActive()) {
        $('.sidebar').addClass('hidden');
        $('.navbar').addClass('hidden');
        $('.footer').addClass('hidden');
      } else {
        $('.sidebar').removeClass('hidden');
        $('.navbar').removeClass('hidden');
        $('.footer').removeClass('hidden');
      }
    });
  }

  setTimeout(function() {$('.time-out').hide('slow');}, 3000);
  icheck();
  setup_datepiker();
});

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
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

function icheck(){
  if($(".icheck-me").length > 0){
    $(".icheck-me").each(function(){
      var $el = $(this);
      var skin = ($el.attr('data-skin') !== undefined) ? "_" + $el.attr('data-skin') : "",
      color = ($el.attr('data-color') !== undefined) ? "-" + $el.attr('data-color') : "";
      var opt = {
        checkboxClass: 'icheckbox' + skin + color,
        radioClass: 'iradio' + skin + color,
      }
      $el.iCheck(opt);
    });
  }
}

function setup_datepiker() {
  $('.input-datepiker').datepicker({
    setDate: new Date(),
    clearBtn: true,
    todayBtn: true,
    language: I18n.locale,
    todayHighlight: true,
    autoclose: true,
    dateFormat: I18n.t('date-js')
  });
}

function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $('#img-prev').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
}

function readURLWithImg(input) {
  if (input) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $('.list_images').prepend('<div class="mblock"><img id="image_preview" src="' + e.target.result + '"/></div>')
    }
    reader.readAsDataURL(input);
  }
}

Array.prototype.remove = function() {
  var what, a = arguments, L = a.length, ax;
  while (L && this.length) {
      what = a[--L];
      while ((ax = this.indexOf(what)) !== -1) {
          this.splice(ax, 1);
      }
  }
  return this;
};
