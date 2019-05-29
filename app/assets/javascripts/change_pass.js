$(document).ready(function() {
  if (window.location.pathname.includes("change_pass")){
    $('#form_change').submit(function () {
      var new_pass = $.trim($('#new_pass').val());
      var con_new_pass = $.trim($('#con_new_pass').val());

      if (new_pass != con_new_pass) {
        alert('Mật khẩu confirmed không chính xác');
        return false;
      }
    });
  }
});
