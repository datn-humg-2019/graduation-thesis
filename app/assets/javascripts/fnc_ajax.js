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
