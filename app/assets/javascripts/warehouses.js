$(document).ready(function() {
  if (window.location.pathname.includes("warehouses")){
    setup_daterange();
  }

  $('body').on('click', '#import_pw', function(){
    var div = $('#import-file');
    if(div.hasClass('hidden')){
      div.removeClass('hidden');
    } else {
      div.addClass('hidden');
    }
  });
});
