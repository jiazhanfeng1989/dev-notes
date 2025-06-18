---
id: 5yvijlnlnsw6eal6htmfa85
title: Gnuplot
desc: ''
updated: 1750235277602
created: 1750224144305
---

# Description
[Gnuplot](http://www.gnuplot.info/documentation.html) is a portable command-line. <br>
It can plot 2D and 3D graphs of functions, data points, and more. <br>
Gnuplot is widely used for scientific and engineering applications, and it supports various output formats, including PNG, PDF, and SVG.

# Documentation
[zh-doc](https://holz.gitbooks.io/gnuplot5help/content/)
[demos](http://www.gnuplot.info/demo/)

# Installation
```bash
# On Debian/Ubuntu
sudo apt-get install gnuplot
# On macOS using Homebrew
brew install gnuplot
# On Windows, download the installer from the official website
```

# Basic Usage
```bash
gnuplot
set terminal png
set output 'output.png'
set title 'Sample Plot'
set xlabel 'X-axis'
set ylabel 'Y-axis'
set grid
set xrange [0:10]
plot sin(x) title 'Sine Wave', cos(x) title 'Cosine Wave'
exit

gnuplot -persist -e "set title 'Sine curve'; plot sin(x)"
```

# Scripting
You can create a script file (e.g., `plot.gp`) with the following content:
```text
set terminal png
set output 'output.png'
set title 'Sample Plot'
set xlabel 'X-axis'
set ylabel 'Y-axis'
set grid
plot sin(x) title 'Sine Wave', cos(x) title 'Cosine Wave'
```

Run the script using:
```bash
gnuplot plot.gp
```

# Data Plotting
To plot data from a file (e.g., `data.txt`):

## Single Curve
``` text
# data.txt
1 2
2 4
3 6
4 8
```
plot 'data.txt' using 1:2 with lines title 'Data Line'

## Multiple Curves
``` text
# data.txt
# x   y1   y2   y3
1     2    3    4
2     4    6    8
3     6    9   12
4     8   12   16
```
plot "data.txt" using 1:2 with lines title "y1","" using 1:3 with lines title "y2", "" using 1:4 with lines title "y3"

``` text
# Curve 1
1 2
2 4
3 6

# Curve 2
1 3
2 6
3 9
```
plot "data.txt" index 0 with lines title "Line A", "" index 1 with lines title "Line B"

## Multiple Files Curves
plot "line1.txt" using 1:2 with lines title "Line 1", "line2.txt" using 1:2 with lines title "Line 2"
