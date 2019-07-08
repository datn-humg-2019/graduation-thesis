$(document).ready(function() {
  $('#user_image').change(function() {show_img(this);});

  $('#category_image').change(function() {show_img(this);});

  $('#product_image').change(function() {
    if(this.files.length == 0){
      $('.list_images').empty();
    }
    for(var i=0; i < this.files.length; i++){
      $('.list_images').empty();
      var element = this.files[i];
      let size_in_megabytes = element.size/1024/1024;
      if (size_in_megabytes > 5) {
        alert('Maximum file size is 5MB. Please choose a smaller file.');
      } else {
        readURLWithImg(element);
      }
    }
  });

  $('#product_warehouse_image').change(function() {
    if(this.files.length == 0){
      $('.list_images').empty();
    }
    for(var i=0; i < this.files.length; i++){
      $('.list_images').empty();
      var element = this.files[i];
      let size_in_megabytes = element.size/1024/1024;
      if (size_in_megabytes > 5) {
        alert('Maximum file size is 5MB. Please choose a smaller file.');
      } else {
        readURLWithImg(element);
      }
    }
  });

  $('body').on('click', '.destroy-image', function(){
    var data = {
      image_id: this.id.split('-')[1]
    };
    ajax_remove_image('POST', '/destroy_image', data, '#' + this.id);
  });
});

function show_img(image){
  let size_in_megabytes = image.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert('Maximum file size is 5MB. Please choose a smaller file.');
  } else {
    $('#img-prev').removeClass('hidden');
    $('.img-avatar').addClass('hidden');
    readURL(image);
  }
}
