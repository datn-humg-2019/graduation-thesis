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
