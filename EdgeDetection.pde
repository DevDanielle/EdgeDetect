/*
  Author: Danielle Kelly

  Perform edge detection using a mask
*/
String fname1 = "emptyroad.jpg", fname2 = "";
String loadName = fname1;
float[][] k1 = {{1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0}}; //Blur
float[][] k2 = {{-1.0, -1.0, -1.0}, {0.0, 0.0, 0.0}, {1.0, 1.0, 1.0}};  //Prewitt horizontal
float[][] k3 = {{-1.0, 0.0, 1.0}, {-1.0, 0.0, 1.0}, {-1.0, 0.0, 1.0}};  //Prewitt vertical
float[][] k4 = {{-1.0, -2.0, -1.0}, {0.0, 0.0, 0.0}, {1.0, 2.0, 1.0}};  //Sobel horizontal
float[][] k5 = {{-1.0, 0.0, 1.0}, {-2.0, 0.0, 2.0}, {-1.0, 0.0, 1.0}};  //Sobel vertical
float[][] k6 = {{-1.0, -1.0, -1.0}, {-1.0, 8.0, -1.0}, {-1.0, -1.0, -1.0}}; //Laplacian
PImage[] img = new PImage[10]; //I used an array of images; you could do it differently
int imgIndex = 0; //Determines which image to display
void setup() {
  size(500, 500);
  surface.setResizable(true);
  //Load and display initial image
  img[0] = loadImage(loadName);
  surface.setSize(img[0].width, img[0].height);
  imgIndex = 0;
  //Add code here to call filter function
  img[1] = convolve(img[0], k1); //blur
  img[2] = convolve(img[0], k2); //Prewitt horizontal
  img[3] = convolve(img[0], k3); //Prewitt vertical
  img[4] = convolve(img[0], k4); //Sobel horizontal
  img[5] = convolve(img[0], k5); //Sobel vertical
  img[6] = convolve(img[0], k6); //Laplacian
  for (int i = 0; i < 5; i++) { //stronger blur
    img[1] = convolve(img[1], k1);
  }
  img[7] = addImages(img[1], img[6]); //blurred + laplacian
  img[8] = subtractImages(img[0], img[1]); 
  img[9] = addImages(img[0], img[8]); //unsharp filter
    
    
}
void draw() {
  image(img[imgIndex], 0, 0);
}
PImage convolve(PImage source, float[][] kernel) {
  PImage target = createImage(source.width, source.height, RGB);
  //Your code here to implement edge detection 
    for (int y = 1; y < source.height - 1; y++) {
    for (int x =1; x < source.width -1; x++) {
      float r = 0, g = 0, b = 0; 
      color c = source.get(x-1, y-1); //upper left neighbow
      r += red(c) * kernel[0][0]; //top left value in kernel
      g += green(c) * kernel[0][0];
      b += blue(c) * kernel[0][0];
      c = source.get(x, y-1); //upper neighbor
      r += red(c) * kernel[0][1]; //middle value in top row of kernel
      g += green(c) * kernel[0][1];
      b += blue(c) * kernel[0][1];
      c = source.get(x+1, y-1); //upper right neighbor
      r += red(c) * kernel[0][2]; //upper right value of kernel
      g += green(c) * kernel[0][2];
      b += blue(c) * kernel[0][2];
      c = source.get(x-1, y); //left neighbor
      r += red(c) * kernel[1][0]; //leftmost value in middle row of kernel
      g += green(c) * kernel[1][0];
      b += blue(c) * kernel[1][0];
      c = source.get(x, y); //target pixel
      r += red(c) * kernel[1][1]; //middle value of kernel
      g += green(c) * kernel[1][1];
      b += blue(c) * kernel[1][1];
      c = source.get(x+1, y); //rightmost neighbor
      r += red(c) * kernel[1][2]; //rightmost value in middle row of kernel
      g += green(c) * kernel[1][2];
      b += blue(c) * kernel[1][2];
      c = source.get(x-1, y+1); //lower left neighbor
      r += red(c) * kernel[2][0]; //bottom left value of kernel
      g += green(c) * kernel[2][0];
      b += blue(c) * kernel[2][0];
      c = source.get(x, y+1); //lower neighbor
      r += red(c) * kernel[2][1]; //middle value in bottom row of kernel
      g += green(c) * kernel[2][1];
      b += blue(c) * kernel[2][1];
      c = source.get(x+1, y+1);
      r += red(c) * kernel[2][2]; //bottom right value of kernel
      g += green(c) * kernel[2][2];
      b += blue(c) * kernel[2][2];
      target.set(x, y, color(r, g, b));
    }
  }    
  return target;
}
//Add two images and return the result (used to add an edge image and for unsharp filtering)
PImage addImages(PImage img1, PImage img2) {
  PImage target = createImage(img1.width, img2.height, RGB); //Assume both images are the same size
  //Your code here to add images; make sure pixels stay in range 
  for (int y = 0; y < img1.height; y++) {
    for (int x = 0; x <img1.width; x++) {
      color c1 = img1.get(x, y);
      color c2 = img2.get(x, y);
      float r1 = red(c1), g1 = green(c1), b1 = blue(c1);
      float r2 = red(c2), g2 = green(c2), b2 = blue(c2);
      float r3 = constrain(r1+r2, 0, 255);
      float g3 = constrain(g1+g2, 0, 255);
      float b3 = constrain(b1+b2, 0, 255);
      target.set(x, y, color(r3, g3, b3));
    }
  }
  return target;
}
//Subtract images - use abs value; one will be a blurred image (used for unsharp filtering)
PImage subtractImages(PImage img1, PImage img2) {
  PImage target = createImage(img1.width, img2.height, RGB); //Assume they are the same size
  //Your code here to subtract images - use abs value
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      color c1 = img1.get(x, y);
      color c2 = img2.get(x, y);
      float r1 = red(c1), g1 = green(c1), b1 = blue(c1);
      float r2 = red(c2), g2 = green(c2), b2 = blue(c2);
      float r3 = abs(r2-r1);
      float g3 = abs(r2-r1);
      float b3 = abs(r2-r1);
      target.set(x, y, color(r3, g3, b3));
    }
  }
  return target;
}
void keyReleased() {
  //Add code to set imgIndex to select image to display
  if (key >= '0' && key <= '9') {
    imgIndex = int(str(key));
  }
}
