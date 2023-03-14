# EuroPanelMaker
Eurorack panel generator for OpenSCAD by [@benjiaomodular](https://www.instagram.com/benjiaomodular/).

![Template preview](preview.png)

## How to use

#### Step 1: Copy the `EuroPanelMaker` folder into your project directory
![Project dir](projectdir.png)

#### Step 2: Include the `panel.scad` file into your project.
```
include <EuroPanelMaker/panel.scad>
```

#### Step 3: Define variables
```
hp = 4;
title = "VCA";
text_depth = 1.6;

// x (in HP column), y (mm), label, rotation (degrees)
pots = [
    [2, 95, "CV AMT"]]; 

// x (in HP column), y (mm), diameter (mm)
leds = [
    [3, 35, 3]]; 
    
// x (in HP column), y (mm), label, rotation (degrees)
jacks = [
    [1, 18, "In"] ,
    [3, 18, "Out"],
    [1, 35, "CV"]]; 

panel_flipped = false;
```

#### Step 4: Call the generatePanel function
```
generatePanel();erminal
```


## Examples


### benjiaomodular
| Name   |      SCAD file      | Preview |
|----------|:-------------:|:------:|
| bong0 | [bong0.scad](examples/benjiaomodular/bong0.scad) | ![Bong0 Preview](examples/benjiaomodular/bong0.png) |
| ce2lfo | [ce2lfo.scad](examples/benjiaomodular/ce2lfo.scad) | ![CE2LFO Preview](examples/benjiaomodular/ce2lfo.png) |
| gate2trig | [gate2trig.scad](examples/benjiaomodular/gate2trig.scad) | ![Gate2Trig Preview](examples/benjiaomodular/gate2trig.png)|

## Features
TODO: List of features
