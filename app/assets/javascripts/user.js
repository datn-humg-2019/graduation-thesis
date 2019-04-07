$(document).ready(function() {
  $('#user_image').change(function() {
    let size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
    } else {
      $('#img-prev').removeClass('hidden');
      $('.img-avatar').addClass('hidden');
      readURL(this);
    }
  });
});
