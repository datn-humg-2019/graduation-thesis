function ajax_remove_image(method, url, data, id){
  $.ajax({
    type: method,
    url: url,
    dataType: 'json',
    data: data,
    success: function(data){
      if(data.status == true) {
        $(id).parent().remove();
      }
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}

function send_add_product_warehouse(data, tr){
  $.ajax({
    type: 'POST',
    url: '/create_product_warehouses',
    dataType: 'json',
    data: data,
    success: function(data){
      if(data['notifi'].type == "1"){
        tr.remove();
        chec_lst_hidden();
        add_product_preview(data.product);
      }
      show_notify('new_product' + tr.find('#index_pw').text(), data['notifi'].type, data['notifi'].message);
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}

function ajax_list_tag(){
  $.ajax({
    type: 'GET',
    url: '/list_tag',
    dataType: 'json',
    success: function(data){
      $('body').prepend('<p class="hidden" id="hidden-tag">' + data.list_tag + '</p>');
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}

var dataTags = (function(){
  var list_tag;

  $.ajax({
    type: "GET",
    url: "/list_tag",
    dataType: "json",
    success : function(data) {
      list_tag = data.list_tag;
    }
  });

  return {getTags : function()
  {
    if (list_tag) return list_tag;
  }};
})();
