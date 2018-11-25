const chooser = document.getElementById('chooser');
const graph = document.getElementById('graph');

fetch(`./mission.csv`).then(res => res.text()).then(csv => {
  let rows = csv.split('\n').reverse().slice(1);
  let data = rows.map(row => row.split(','));
    console.log(data);
  plot(data[0][0], true);

  data.forEach(entry => {
    let opt = document.createElement('option');
    opt.textContent = `${entry[1]} (${entry[2]})`;
    opt.setAttribute('value', entry[0]);
    chooser.appendChild(opt);
  });
});

chooser.onchange = function() {
  plot(chooser.value);
}
//window.setInterval(() => plot(chooser.value), 5000)

function plot(name, newPlot) {
  fetch(`./${name}`).then(res => res.text()).then(csv => {
    let rows = csv.split('\n');

    rows.forEach(row => {
      if (row.indexOf('#')===0) {
        let [command, ...values] = row.split(' ');
        switch(command) {
          case '#ADDELEMENT':
            return rows[0] += ','+values[0];
        }
      }
    });

    rows = rows.filter(r => (r.indexOf('#')!==0 && r.indexOf('//')!==0));
    let data = rows.map(row => row.split(','));

    let sets = [];
    data[0].forEach((name, index) => {
      if (name.indexOf('__')===0) {
        return; // ignore for now..
      }

      let x = [];
      let y = [];
      data.slice(1).forEach((row, line) => {
        x.push(row[0]);
        y.push(row[index]);
      });

      sets.push({
        x,
        y,
        name: name.indexOf('_')===0?name.slice(1):name,
        visible: name.indexOf('_')===0?'legendonly':true,
      });
    });

    console.log(sets);

    let template;
    if (!newPlot) template = Plotly.makeTemplate(graph)
    return Plotly.newPlot( graph, sets.slice(1), {title: 'kOS Telemetry viewer', template}, {responsive: true} );
  });
}
