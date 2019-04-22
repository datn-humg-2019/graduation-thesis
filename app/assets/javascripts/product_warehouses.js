$(document).ready(function() {
  var lst_product = [];
  reload_list_product();

  $('body').on('click', '#add_new_pw', function(){
    var count_max = get_count_max();
    var tbl = $('#tbl_pw').find('tbody');
    tbl.prepend(render_tr(count_max));
    setup_datepiker();
    chec_lst_hidden();
    add_product_to_choose(count_max);
    set_up_chosen();
    currency_input();
  });

  $('body').on('click', '.create-class', function(){
    var tr = $(this).closest('tr');
    var data = {
      product_warehouse: {
        product_id: tr.find('.select_product').val(),
        count: tr.find('#count_pw').val(),
        price_origin: localStringToNumber(tr.find('#price_origin_pw').val()),
        price_sale: localStringToNumber(tr.find('#price_sale_pw').val()),
        mfg: tr.find('#mfg_pw').val(),
        exp: tr.find('#exp_pw').val(),
      }
    };
    if(data.product_warehouse.count == 0 && data.product_warehouse.price_origin == 0 && data.product_warehouse.price_sale == 0
      && data.product_warehouse.mfg == "" && data.product_warehouse.exp == "" && data.product_warehouse.product_id == null) {
      alert("thieu thong tin");
    } else {
      send_add_product_warehouse(data, tr);
      reload_list_product();
    }
  });

  $('body').on('click', '.destroy-class', function(){
    $(this).closest('tr').remove();
    chec_lst_hidden();
  });
});

function reload_list_product() {
  if (window.location.pathname.includes("warehouses")){
    ajax_list_product();
  }
}

function add_product_preview(image) {
  $('#lst_preview_product').append('\
    <div class="col-sm-2">\
        <div class="item">\
          <image SRC="'+ image +'" class="img-thumbnail"></image>\
        </div>\
    </div>');
}

function chec_lst_hidden() {
  var tbl = $('.list_pw');
  var rowCount = $('#tbl_pw tr').length;
  if (rowCount == 1){
    tbl.addClass('hidden');
  } else {
    tbl.removeClass('hidden');
  }
}

function render_tr(count_max){
  return '<tr><td id="index_pw">'+ count_max +'</td>\
          <td><select class="form-control chosen select_product" id="select_product_'+ count_max +'"></select></td>\
          <td><input class="form-control" type="number" value="0" min="1" id="count_pw"></td>\
          <td><input class="form-control" type="currency" value="0" min="0" id="price_origin_pw"></td>\
          <td><input class="form-control" type="currency" value="0" min="0" id="price_sale_pw"></td>\
          <td><input class="input-datepiker form-control" type="text" placeholder="MFG Date" id="mfg_pw" readonly="true"></td>\
          <td><input class="input-datepiker form-control" type="text" placeholder="EXP Date" id="exp_pw" readonly="true"></td>\
          <td><button class="btn btn-success create-class">\
          <i class="fa fa-save"></i></button>\
          <button class="btn btn-default destroy-class">\
          <i class="fa fa-times-circle"></i></button></td></tr>';
}

function currency_input() {
  var currencyInput = $('input[type="currency"]');
  for(element in currencyInput){
    currencyInput.bind('focus', onFocus);
    currencyInput.bind('blur', onBlur);
  }
}

function localStringToNumber( s ){
  return Number(String(s).replace(/[^0-9.-]+/g,""));
}

function onFocus(e){
  var value = e.target.value;
  e.target.value = value ? localStringToNumber(value) : '';
}

function onBlur(e){
  var value = e.target.value;

  const options = {
      maximumFractionDigits : 2,
      currency              : "VND", // https://www.currency-iso.org/dam/downloads/lists/list_one.xml
      style                 : "currency",
      currencyDisplay       : "symbol"
  }

  e.target.value = value ? localStringToNumber(value).toLocaleString(undefined, options) : ''
}

function add_product_to_choose(id_choose){
  var select = $('#select_product_' + id_choose);
  select.empty();
  if(lst_product.length > 0){
    for(var i = 0; i < lst_product.length; i++){
      select.append(`<option value="${lst_product[i][0]}">${lst_product[i][1]}</option>`);
    }
  }
  select.trigger("chosen:updated");  
}

function get_count_max() {
  var max = 0;
  $('td[id="index_pw"]').each(function(){
    if(parseInt(this.textContent) > max)
      max = parseInt(this.textContent);
  });
  return max + 1;
}

function ajax_list_product(){
  $.ajax({
    type: 'GET',
    url: '/list_product',
    dataType: 'json',
    success: function(data){
      lst_product = data.list_product
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}
