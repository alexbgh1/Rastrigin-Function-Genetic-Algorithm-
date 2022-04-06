// PSO de acuerdo a Talbi (p.247 ss)

PImage surf; // imagen de referencia
// ===============================================================

//Parametrizable
int genes = 100; //Numero de genes
float Cr=1; //Probabilidad del cruzamiento
float Mu=0.06; //Probabilidad de mutacion
int k = 2; //K seleccionados de los N genes, para luego escoger al mejor; Se asume que genes>=k e idealmente genes>>>k
float d = 15; // radio del círculo, solo para despliegue
int iter = 20;


//Variables utilizadas en Seleccion, Paso 1
int r; //primer seleccionado de los k
float bestFitSelected;
float bestXSelected;
float bestYSelected;

//Variables de arreglos y datos de display
Particle[] fl; // arreglo de generacion actual
Particle[] newGen; // arreglo de nueva generacion
float gbestx, gbesty, gbest; // posición y fitness del mejor global
float dominio = 5.12;
float promedioGen=0;
float bestPromedio;
int gen_to_best_promedio = 0;
int gen = 0, gen_to_best = 0; //número de evaluaciones, sólo para despliegue

//posPadre - Paso 2
int posPadre;


class Particle{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)

  // ---------------------------- Constructor
  // Se inicializa un Gen totalmente aleatorio entre el rango del dominio
  Particle(){
    //Particulas con gen aleatorio x e y
    x = random (-5.12,5.12); y = random(-5.12,5.12);
    //Funcion de evaluacion Rastrigin 2d
    fit = 10 * 2 + (pow(x,2) - 10*cos(2*PI*x)) + (pow(y,2) - 10*cos(2*PI*y));

  }


  //----------------------------- Constructor con parametros, util para crear hijo1 e hijo2
  // Al tener un X e Y nuevos, se recalcula el Fit
  Particle(float x1, float y1){
    x = x1; y=y1;
    fit = 10 * 2 + (pow(x,2) - 10*cos(2*PI*x)) + (pow(y,2) - 10*cos(2*PI*y));

  }
  
  
  //----------------------------- Constructor con parametros, util para crear las nuevas generaciones
  // Solo se traspasan los datos
  Particle(float x2, float y2, float fit2){
    x = x2; y=y2; fit=fit2;
  }
  
  // ---------------------------- Evalúa partícula
  float Eval(){ //recibe imagen que define función de fitness
    promedioGen = promedioGen + fit;
    if (fit < gbest){ // actualiza global best
      gbest = fit;
      gbestx = x;
      gbesty = y;
      gen_to_best = gen;
      println(str(gbest)+", gen:"+gen);
    };
    return fit;
  }
 
  
  // ------------------------------ despliega partícula
  void display(){
    // ajusta la posicion de las particulas a los pixeles de la imagen
    int ejeX = int( (5.12+x)/(2*dominio) * width );
    int ejeY = int( abs(y-5.12)/(2*dominio) * height );
    color c=surf.get(ejeX, ejeY); 
    fill(c);
    stroke(#ff0000);
    ellipse (ejeX,ejeY,d,d); 
  }
}
//fin de la definición de la clase Particle


// dibuja punto azul en la mejor posición y despliega números
void despliegaBest(){
  fill(#0000ff);
  if (gbestx<0 )
  ellipse((gbestx+5.12)*50,(gbesty+5.12)*50,d,d);
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#000000);
  text("Best fitness: "+str(gbest)+", x: "+str(gbestx)+" y: "+str(gbesty)+"\ngen to best: "+str(gen_to_best)+"\nPromedio gen: "+str(promedioGen)+" | best promedio: "+str(bestPromedio)+", gen: "+str(gen_to_best_promedio)+"\ngen: "+str(gen),10,20);
}

// ===============================================================

void setup(){  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  //Setea la ventana a una proporcion 1:100*dim
  size(512,512); //setea width y height (de acuerdo al tamaño de la imagen)
  //Carga imagen referencial
  surf = loadImage("rastrigin_512.jpg");
  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  // Crea arreglo de objetos partículas
  fl = new Particle[genes];
  newGen = new Particle[genes];
  
  //Crea la primera particula
  fl[0] = new Particle();
  
  //La toma como referencia junto a sus datos
  promedioGen = fl[0].fit;
  gbest = fl[0].fit;
  gbestx = fl[0].x;
  gbesty = fl[0].y;
  
  //Crea las demas particulas
  for(int i =1;i<genes;i++){
    fl[i] = new Particle();
    fl[i].Eval();
  }
  
  bestPromedio = promedioGen;
  
}

void draw(){

  image(surf,0,0);
  delay(50);
  
  //NOTA IMPORTANTE: EL DISPLAY SE REALIZA AL INICIO, SE MOSTRARA SIEMPRE EL RESULTADO FINAL
  // DONDE SI BIEN REALIZA EL COMPUTO DE CRUZAMIENTO Y MUTACION, NO SE VE REFLEJADO HASTA QUE YA
  // SE TIENE LA REINSERCION HECHA, ES DECIR, PUEDE HABER UNA MEZCLA DE PARTICULAS DE LA GEN ANTERIOR Y LA NUEVA
  // DONDE PREVALECEN LAS MEJORES EN UN 1 A 1
  
  //Muestra las particulas
  for(int i = 0;i<genes;i++){
    fl[i].display();
  }
  
  
  //Deslpiega mejores resultados
  despliegaBest();
  //Resetea el promedio de generacion
  promedioGen=0;
  
  
  //PASO 1 - - - Selecciona por torneo
  //Entre los N genes, selecciona K elementos, y añade el mejor a la proxima generacion, se repite N veces
  for(int i=0; i<genes;i++){

    //Genera una particula de referencia
    r = int(random(genes));
    bestFitSelected = fl[r].fit;
    bestXSelected = fl[r].x;
    bestYSelected = fl[r].y;
    //Luego selecciona K particulas de manera aleatoria y va dejando la mejor de esas K
    for(int j=1;j<k;j++){
      r = int(random(genes));
      if (fl[r].fit < bestFitSelected){
        bestFitSelected = fl[r].fit;
        bestXSelected = fl[r].x;
        bestYSelected = fl[r].y;  
      }
    }
    //Finalmente lo ingresa a una nueva generacion
    newGen[i] = new Particle(bestXSelected, bestYSelected, bestFitSelected);
  }
  
  
  //PASO 2 - - - Cruzamiento
  //
  int cruzar = 0;
  int i=0;

  // Secuencial - Recorre los N elementos, en caso de tener un Padre y Madre, los cruza, sobreescribiendo una combinación de ellos en newGen
  for (i=0; i<genes; i++){
    
    //Encuentra un padre o una madre
    if (Cr > random(1)){
      cruzar++;
      
      //Encontro al padre
      if (cruzar == 1) {
        posPadre = i;
      };
      
      //Encontro a la madre, por ende, con Padre y Madre se generan los "hijo1" e "hijo2"
      if (cruzar == 2){
        Particle padre = newGen[posPadre];
        Particle madre = newGen[i];
        Particle hijo1 = new Particle ((padre.x+madre.x)/2, (padre.y+madre.y)/2);
        Particle hijo2 = new Particle (madre.x, padre.y);
        
        //Sobreescribe a los padre y madre con los hijos
        newGen[posPadre] = hijo1;
        newGen[i] = hijo2;
        
        //Reinicia la variable para encontrar algun nuevo par
        cruzar = 0;
      }
    }
  }
  
  
  //PASO 3 - - - Mutación
  for ( i = 0; i<genes ; i++){
    
    //Si existe mutacion, considera la particula en la posicion i como la mutada
    if (Mu > random(1)){
      
      //Genera la mutacion
      float randomX = random(-5.12,5.12);
      float randomY = random(-5.12,5.12);
      
      //Evalua en X - Si se pasa de un borde, lo deja en el extremo horizontal
      if (newGen[i].x + randomX > 5.12) newGen[i].x = 5.12;
      else if (newGen[i].x + randomX < -5.12) newGen[i].x = -5.12;
      else newGen[i].x = newGen[i].x + randomX;
      
      //Evalua en Y - Si se pasa de un borde, lo deja en el extremo vertical
      if (newGen[i].y + randomY > 5.12) newGen[i].y = 5.12;
      else if (newGen[i].y + randomY < -5.12) newGen[i].y = -5.12;
      else newGen[i].y = newGen[i].y + randomY;
      
      //Recalcula su fit que se movieron los eje X e Y
      newGen[i].fit = 10 * 2 + (pow(newGen[i].x,2) - 10*cos(2*PI*newGen[i].x)) + (pow(newGen[i].y,2) - 10*cos(2*PI*newGen[i].y));

    }
  }
  
  //PASO 4 - - - Re insercion
  
  //Simple - Por sobreescritura
  //fl = newGen;
  
  
  //Torneo simple, Compara la posicion "i" de la generacion anterior y la nueva (fl y newGen)
  for (i=0;i<genes;i++){
    if (fl[i].fit > newGen[i].fit){
      fl[i] = newGen[i];
    } 
  }
  
  
  //Evaluacion, calcula la mejor particula y el promedio (solo la suma)
  for(i = 0;i<genes;i++){
    fl[i].Eval();
  }
  
  
  
  //Calcula el promedio (divide por N genes)
  promedioGen=promedioGen/genes;
  //Calcula el mejor promedio
  if (promedioGen < bestPromedio){
    bestPromedio = promedioGen;
    gen_to_best_promedio = gen; 
  } 
  
  
  //Aumenta la generacion y decrementa la iteracion faltante
  gen++;
  iter--;
  
  if(iter+2 == 0 ){
    delay(1000);
    exit();
  }
}
