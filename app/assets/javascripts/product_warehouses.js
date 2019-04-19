$(document).ready(function() {
  var lst_product = [];
  if (window.location.pathname.includes("product_warehouses/new")){
    ajax_list_product();
  }

  $('body').on('click', '#add_new_pw', function(){
    var count_max = get_count_max();
    var tbl = $('#tbl_pw').find('tbody');
    tbl.prepend(render_tr(count_max));
    setup_datepiker();
    add_product_to_choose(count_max);
    set_up_chosen();
  });

  $('body').on('click', '.create-class', function(){
    var tr = $(this).closest('tr');
    var data = {
      product_warehouse: {
        product_id: tr.find('.select_product').val(),
        count: tr.find('#count_pw').val(),
        price_origin: tr.find('#price_origin_pw').val(),
        price_sale: tr.find('#price_sale_pw').val(),
        mfg: tr.find('#mfg_pw').val(),
        exp: tr.find('#exp_pw').val(),
      }
    };
    send_add_product_warehouse(data, tr);
  });

  $('body').on('click', '.destroy-class', function(){
    $(this).closest('tr').remove();
  });
});

function render_tr(count_max){
  return '<tr><td id="index_pw">'+ count_max +'</td>\
          <td><select class="form-control chosen select_product" id="select_product_'+ count_max +'"></select></td>\
          <td><input class="form-control" type="number" value="0" id="count_pw"></td>\
          <td><input class="form-control" type="number" value="0" id="price_origin_pw"></td>\
          <td><input class="form-control" type="number" value="0" id="price_sale_pw"></td>\
          <td><input class="input-datepiker form-control" type="text" placeholder="MFG Date" id="mfg_pw" readonly="true"></td>\
          <td><input class="input-datepiker form-control" type="text" placeholder="EXP Date" id="exp_pw" readonly="true"></td>\
          <td><button class="btn btn-success create-class">\
          <i class="fa fa-save"></i></button>\
          <button class="btn btn-default destroy-class">\
          <i class="fa fa-times-circle"></i></button></td></tr>';
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
