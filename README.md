## MATGRID

MATGRID is the simulation tool for researchers and educators that is easy-to-use MATLAB package, with source code released under MIT License, inspired by Matpower. It allows a variety of display and manipulation options.

The software package provides the solution of the AC and DC power flow, the non-linear and DC state estimation, as well as the state estimation with PMUs, with standalone measurement generator.

<table>
    <tbody>
        <tr>
            <td align="center"><a href="https://github.com/mcosovic/MATGRID/wiki/Power-Flow" itemprop="contentUrl" data-size="600x400"> <img src="https://github.com/mcosovic/PowerMarieEdu/blob/master/doc/figures/modulepf.png"></td>
            <td align="center"><a href="https://github.com/mcosovic/MATGRID/wiki/State-Estimation" itemprop="contentUrl" data-size="600x400"> <img src="https://github.com/mcosovic/PowerMarieEdu/blob/master/doc/figures/modulese.png"></td>
            <td align="center"><a href="https://github.com/mcosovic/MATGRID/wiki/Measurement-Generator" itemprop="contentUrl" data-size="600x400"> <img src="https://github.com/mcosovic/PowerMarieEdu/blob/master/doc/figures/modulemg.png"</td>
        </tr>
    </tbody>
</table>

We have tested and verifed simulation tool using different scenarios to best of our ability. As a user of this simulation tool, you can help us to improve future versions, we highly appreciate your feedback about any errors, inaccuracies, and bugs. For more information, please visit our [wiki](https://github.com/mcosovic/MATGRID/wiki/MATGRID) site.

###  Fast Run Power Flow
```
runpf('ieee14_20', 'nr', 'main', 'flow');
runpf('ieee14_20', 'dc', 'main', 'flow');
```

###  Fast Run State Estimation
```
runse('ieee118_186', 'nonlinear', 'estimate');
runse('ieee118_186', 'dc', 'estimate');
runse('ieee14_20', 'pmu', 'pmuOptimal', 'estimate');
```

###  Changelog
Major changes:
- 2019-03-28 Added Gauss-Seidel, decoupled Newton-Raphson and fast decoupled Newton-Raphson algorithm
- 2019-03-21 Added least absolute value (LAV) state estimation
- 2019-03-19 Added bad data processing
