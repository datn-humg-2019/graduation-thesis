$(document).ready(function() {
  if (window.location.pathname == '/'){
    var old_width = $('.chartAreaWrapperCount').width();
    var old_width_p = $('.chartAreaWrapperPrice').width();

    ajax_io(old_width);
    ajax_p_io(old_width_p);

    $('#select-times').change(function(){
      ajax_io(old_width);
    });

    $('#select-times-price').change(function(){
      ajax_p_io(old_width_p);
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

function ajax_io(old_width) {
  $.ajax({
    type: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    url: '/list_io',
    data: {type_count: $('#select-times').val()},
    dataType: 'json',
    success: function(data){
      var labels = [];
      var datasets = [];
      if($('#select-times').val() == 6){
        labels = data.label_year;
      } else {
        labels = createLables($('#select-times').val());
      }
      datasets = [
        createDataset(data.list_o, '#51CACF', 'Hàng hóa xuất'),
        createDataset(data.list_i, '#fbc658', 'Hàng hóa nhập')
      ];
      var data_size = labels.length;
      if (data_size > 10) {
        new_width = Math.round(data_size * old_width / 10)
        $('.chartAreaWrapperCount').width(new_width);
      } else {
        $('.chartAreaWrapperCount').width(old_width);
      }
      $('#io-chart').remove();
      $('.chartAreaWrapperCount').append('<canvas id="io-chart"></canvas>');
      new Chart(document.getElementById("io-chart"), createConfig(labels, datasets, false));
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}

function ajax_p_io(old_width_p) {
  $.ajax({
    type: 'POST',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    url: '/list_p_io',
    data: {type_price: $('#select-times-price').val()},
    dataType: 'json',
    success: function(data){
      var labels = [];
      var datasets = [];
      if($('#select-times-price').val() == 6){
        labels = data.label_year;
      } else {
        labels = createLables($('#select-times-price').val());
      }
      datasets = [
        createDataset(data.list_o, '#69EC0F', 'Tiền bán hàng'),
        createDataset(data.list_i, '#EC120F', 'Tiền nhập hàng')
      ];

      var data_size = labels.length;
      if (data_size > 10) {
        new_width = Math.round(data_size * old_width_p / 10)
        $('.chartAreaWrapperPrice').width(new_width);
      } else {
        $('.chartAreaWrapperPrice').width(old_width_p);
      }
      $('#io-p-chart').remove();
      $('.chartAreaWrapperPrice').append('<canvas id="io-p-chart"></canvas>');
      new Chart(document.getElementById("io-p-chart"), createConfig(labels, datasets, true));
    },
    error: function (error){
      console.log(error);
      alert('has an error');
    }
  });
}

function createConfig(labels, datasets, is_price) {
  return {
    type: 'line',
    hover: false,
    data: {
      labels: labels,
      datasets: datasets
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
        callbacks: {
          label: function(tooltipItems, data) {
            if(is_price == true){
              return data.datasets[tooltipItems.datasetIndex].label + ':  ' + currencyFormatVND(tooltipItems.yLabel);
            }
            return data.datasets[tooltipItems.datasetIndex].label + ':  ' +tooltipItems.yLabel.toString();
          }
        }
      },
      legend: {
        display: false,
        position: 'top'
      }
    }
  };
}
