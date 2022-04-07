<h1>Rastrigin-Function-Genetic-Algorithm</h1>
<h3><b>Uso de la función de Rastrigin</b></h3>
<p>El principal uso de esta función así como <a href="https://en.wikipedia.org/wiki/Test_functions_for_optimization">muchas otras</a> está en testeos de optimización de funciones.</p>
<p><b>Rastrigin 2D, dominio [x,y] [(-5.12,5.12),(-5.12,5.12)]<br>f(x,y) = 20 * x^2 - 10*cos(2 * PI * x) + y^2 - 10*cos(2 * PI * y) </b></p>
<h3><b>Algoritmo genético</b></h3>
<p>En resumidas cuentas es la creación de una generación 0 que es evaluada, para luego cíclicamente aplicar una <b>Selección, Cruzamiento, Mutación, Evaluación</b> y <b>Reinserción</b>. Como se ve en la imágen:</p>
<img src="https://raw.githubusercontent.com/alexbgh1/Rastrigin-Function-Genetic-Algorithm-/main/300px-Evolutionary_algorithm.svg.png">
<h4><b>Parámetros</b></h4>
<p><b>Genes (int [2..+100]):</b> Cantidad de "puntos" en el espacio, constan de un <b>x</b> e <b>y</b>, para además calcular un <b>fit</b> que es el valor de evaluar f(x,y).</p>
<p><b>K (int [2..Genes]):</b> Son los K elementos seleccionados de los <b>Genes,</b> de los cuales se saca al mejor. Idealmente <b>Genes >>> K</b> para variabilidad </p>
<p><b>Cr (float [0..1]):</b> Probabilidad de cruzamiento, una vez <b>Seleccionadas</b> los genes va tomando un <b>padre</b> y una <b>madre</b> de manera secuencial, de los que toma algunos valores para combinarlos</p>
<p><b>Mu (float [0..1]):</b> Probabilidad de mutación, una vez cruzados los genes le aplica una mutación que es equivalente a mover su variable <b>X</b> o <b>Y</b> en el rango de su dominio</p>
<p><b>Reinserción:</b> Hay 2 métodos, 1 es sobreescribir la nueva generación en la vieja y la otra es ir 1 por 1 (de la generación antigua y nueva) comparando cuál es mejor en <b>fit</b></p>
<h4><b>Selección</b></h4>
<p>Es la selección de las nuevas generaciones, en este programa se aplica seleccionar <b>K</b> elementos,</p>
