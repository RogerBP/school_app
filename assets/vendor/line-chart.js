import Chart from 'chart.js/auto';
class LineChart {
  constructor(ctx, chart_data) {
    const config = this.getConfig(chart_data);
    config.data = this.getData(chart_data);
    this.chart = new Chart(ctx, config);
    this.showChart();
  }

  getData(chart_data){
    // console.log("getData", chart_data);
    const data = {
      labels: chart_data.labels,
      datasets: chart_data.datasets
    }

    if (chart_data && chart_data.datasets) {
      chart_data.datasets.forEach(ds => {
        ds.borderWidth = 2;
        ds.borderRadius = 5;      
        ds.tension = 0.0
      });
    }

    return data;
  }

  getConfig(chart_data) {
    let config = {
      type: 'line',
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: chart_data.title
          }
        }
      }
    };    
    return config;
  }

  change_data(payload) {
    let chart_data = payload.chart_data;
    // console.log("change_data", chart_data);
    const config = this.getConfig(chart_data);
    config.data = this.getData(chart_data);

    this.chart.config.options = config.options;
    this.chart.config.data = config.data;
    this.chart.update();
    // console.log("===> this.chart.update(); <===");
    // this.showChart();
  }

  showChart(){
    console.log("<===> showChart <===>");
    console.log("options", this.chart.config.options);
    console.log("data", this.chart.config.data);
    console.log("====> showChart <====");
  }
}

let LineChartHook = {
    mounted() {
      // console.log("====> LineChartHook <====");

      this.chart = new LineChart(this.el, JSON.parse(this.el.dataset.chartData)); 

      this.handleEvent("load-data", (chart_data) => {
        // console.log("====> load_data event <====");
        console.log(chart_data);
        this.chart.change_data(chart_data);       
      });

      console.log(this);

    },
    
    destroyed() {
      // console.log("====> DESTROYED <====");
      this.chart = null;
    }    
}

export default LineChartHook;
