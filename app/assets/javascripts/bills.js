$(document).ready(function() {
  $(".image-checkbox").each(function () {
    if ($(this).find('input[type="checkbox"]').first().attr("checked")) {
      $(this).addClass('image-checkbox-checked');
    }
    else {
      $(this).removeClass('image-checkbox-checked');
    }
  });

  $(".image-checkbox").on("click", function (e) {
    var pw_count = $(this).children('img').attr('tooltip_title').split('*').slice(-1).pop();
    var pw_price_sale = $(this).children('img').data('price');
    if(parseInt(pw_count) == 0){
      alert('hàng đã hết');
    } else {
      $(this).toggleClass('image-checkbox-checked');
      var $checkbox = $(this).find('input[type="checkbox"]');
      if($checkbox.prop("checked") == false){
        add_row_to_table($checkbox.data('id'), $checkbox.data('name'), pw_count, pw_price_sale);
      } else {
        $('#'+$checkbox.data('id')).closest('tr').remove();
      }
      $checkbox.prop("checked",!$checkbox.prop("checked"));
    }
    e.preventDefault();
  });

  $('body').on('click', '.bill-destroy-class', function(){
    $(this).closest('tr').remove();
    var check_bll = $('input[data-id="'+this.id+'"]');
    check_bll.prop("checked", false);
    check_bll.closest('label').toggleClass('image-checkbox-checked');
  });
});

function add_row_to_table(id, name, pw_count, pw_price_sale){
  var count_max = get_count_bill_max();
  var tbl = $('#tbl_pw_bill').find('tbody');
  tbl.prepend(render_tr_bil(count_max, id, name, pw_count, pw_price_sale));
  currency_input();
}

function render_tr_bil(count_max, id, name, pw_count, pw_price_sale){
  return '<tr><td id="index_bill">'+ count_max +'</td>\
          <td><input class="hidden" name="bill_pw[]" type="number" value="'+id.split('-')[1]+'">'+name+'</td>\
          <td><input class="form-control" name="bill_count[]" type="number" value="0" min="1" max="'+pw_count+'" required="true"></td>\
          <td><input class="form-control" name="bill_price[]" type="currency" value="'+pw_price_sale+'" min="0" required="true"></td>\
          <td><button class="btn btn-default bill-destroy-class" id="'+id+'">\
          <i class="fa fa-times-circle"></i></button></td></tr>';
}

function get_count_bill_max() {
  var max = 0;
  $('td[id="index_bill"]').each(function(){
    if(parseInt(this.textContent) > max)
      max = parseInt(this.textContent);
  });
  return max + 1;
}
