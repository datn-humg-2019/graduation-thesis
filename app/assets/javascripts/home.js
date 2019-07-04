$(document).ready(function() {
  if (window.location.pathname == '/'){
    var old_width = $('.chartAreaWrapper2').width();

    var io_config = {
      type: 'line',
      hover: false,
      data: {
        labels: createLables($('#select-times').val()),
        datasets: []
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        responsiveAnimationDuration: 0,
        animation: {
          duration: 0
        },
        hover: {
          mode: 'nearest',
          intersect: true,
          animationDuration: 0
        },
        tooltips: {
          mode: 'index',
          intersect: false,
        },
        legend: {
          display: false,
          position: 'top'
        }
      }
    };

    ajax_io(io_config, old_width);

    $('#select-times').change(function(){
      ajax_io(io_config, old_width);
    });
  }
});

function createDataset(data, color, label_name) {
  var data = {
    label: label_name,
    data: data,
    fill: false,
    borderColor: color,
    backgroundColor: 'transparent',
    pointBorderColor: color,
    pointRadius: 4,
    pointHoverRadius: 4,
    pointBorderWidth: 6,
  };
  return data;
}

function createLables(type) {
  var labels = [];
  switch(parseInt(type)) {
    case 1:
      labels = date_in_week(new Date()).map(day => formatDateNotYear(day));
      break;
    case 2:
      labels = getDaysInThisMonth().map(day => formatDateNotYear(day));
      break;
    case 3:
      labels = getDaysInLastMonth().map(day => formatDateNotYear(day));
      break;
    case 4:
      labels = ['Tháng 1','Tháng 2','Tháng 3','Tháng 4','Tháng 5','Tháng 6','Tháng 7','Tháng 8','Tháng 9','Tháng 10','Tháng 11','Tháng 12'];
      break;
    case 5:
      date = new Date();
      labels = [1,2,3,4,5,6,7,8,9,10,11,12].map(i => i+"/"+(date.getFullYear() - 1));
      break;
    case 6:
      labels = [];
      break;
    default:
  }
  return labels;
}

function ajax_io(io_config, old_width) {
  $.ajax({
    type: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    url: '/list_io',
    data: {type: $('#select-times').val()},
    dataType: 'json',
    success: function(data){
      if($('#select-times').val() == 6){
        io_config.data.labels = data.label_year;
      } else {
        io_config.data.labels = createLables($('#select-times').val());
      }
      io_config.data.datasets = [
        createDataset(data.list_o, '#51CACF', 'Hàng hóa xuất'),
        createDataset(data.list_i, '#fbc658', 'Hàng hóa nhập')
      ];

      var data_size = data.list_o.length;
      if (data_size > 10) {
        new_width = Math.round(data_size * old_width / 10)
        $('.chartAreaWrapper2').width(new_width);
      } else {
        $('.chartAreaWrapper2').width(old_width);
      }
      $('#io-chart').remove();
      $('.chartAreaWrapper2').append('<canvas id="io-chart"></canvas>');
      new Chart(document.getElementById("io-chart"), io_config);
    },
    error: function (error){
      console.log(error);
      debugger
      alert('has an error');
    }
  });
}
