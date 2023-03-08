

function SendData(data,cb) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            if (cb) {
                cb(xhr.responseText)
            }
        }
    }
    xhr.open("POST", 'https://renzu_controller/nuicb', true)
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify(data))
}
let getEl = function( id ) { return document.getElementById( id )}
 
function setcontrol(type,index) {
    console.log(type,index)
    return SendData({msg: 'carcontrol', type: type, index: index})
} 

window.addEventListener('message', function (table) {
    let event = table.data;
    if (event.show) {
        getEl('body').style.opacity = '1.0'
    } else if (event.show == false) {
        getEl('body').style.opacity = '0.0'
    }

    if (event.plate) {
        getEl('plate').innerHTML = event.plate
    }
 
})

const range = document.getElementById('range');
document.documentElement.style.setProperty("--range", (range.value * 1.1) * 100 + "%");
range.setAttribute('value', range.value);
range.addEventListener("input", () => {
    console.log(range.value)
    range.setAttribute('value', range.value);
    document.documentElement.style.setProperty("--range", (range.value * 1.1) * 100 + "%");
    SendData({msg: 'height', val: range.value})
});

let colors = {
    ['white'] : { r: 255, g: 255, b: 25},
    ['orange'] : { r:  100, g: 64, b: 0},
    ['black'] : { r: 0, g: 0, b: 0},
    ['blue'] : { r: 0, g: 0, b: 100},
    ['cyan'] : { r: 0, g: 255, b: 255},
    ['purple'] : { r: 62, g: 12, b: 94},
    ['red'] : { r: 255, g: 1, b: 1},
}
var rad = document.neon.neoncolor;
var prev = null;
for(var i = 0; i < rad.length; i++) {
    rad[i].onclick = function () {
        (prev)? console.log(prev.value):null;
        if(this !== prev) {
            prev = this;
        }
        console.log(this.value)
        SendData({msg: 'neon', val: colors[this.value]})
    };
}

var rad2 = document.headlight.color;
var prev2 = null;
for(var i = 0; i < rad2.length; i++) {
    rad2[i].onclick = function () {
        (prev2)? console.log(prev2.value):null;
        if(this !== prev2) {
            prev2 = this;
        }
        console.log(this.value)
        SendData({msg: 'headlight', val: colors[this.value]})
    };
}

document.addEventListener("keydown", (event) => {
    if (event.keyCode == 27 || event.keyCode === 36 || event.keyCode === 8) {
      return SendData({msg: 'close'})
    }
});

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null;
}

function SetNeonCustom(event) {
    SendData({msg: 'customneon', val: { r: hexToRgb(event.target.value).r, g:hexToRgb(event.target.value).g, b:hexToRgb(event.target.value).b}})
}

function SetCustomheadlight(event) {
    SendData({msg: 'customheadlight', val: { r: hexToRgb(event.target.value).r, g:hexToRgb(event.target.value).g, b:hexToRgb(event.target.value).b}})
}

function SetNeonStyle(val) {
    SendData({msg: 'neonstyle', val: val})
}

function ToggleNeon() {
    SendData({msg: 'toggleneon', val: true})
}

function ToggleLights() {
    SendData({msg: 'togglelights', val: true})
}


colorPicker = document.querySelector("#customneon");
colorPicker.addEventListener("input", SetNeonCustom, false);
colorPicker.addEventListener("change", SetNeonCustom, false);

colorPicker = document.querySelector("#customheadlight");
colorPicker.addEventListener("input", SetCustomheadlight, false);
colorPicker.addEventListener("change", SetCustomheadlight, false);