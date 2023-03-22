import java.net.DatagramPacket; //<>//
import java.net.DatagramSocket;
import java.awt.*;    


int port = 3333;
DatagramSocket dsocket = null;
boolean initializedCanvas = false;

// Create a buffer to read datagrams into. If a
// packet is larger than this buffer, the
// excess will simply be discarded!
byte[] buffer = new byte[2048];

// Create a packet to receive data into the buffer
DatagramPacket packet = new DatagramPacket(buffer, buffer.length);

PImage img;
PImage img_stress;
PImage img_nostress;
int currentSizeFactor = 2;

int lastTimeSaved;
int total_1 = 0;
int total_2 = 0;
int total_3 = 0;
int total_4 = 0;
int total_5 = 0;
int total_0 = 0;
int cnt = 0;
int avg_0 = 0;
int avg_1 = 0;
int avg_2 = 0;
int avg_3 = 0;
int avg_4 = 0;
int avg_5 = 0;
int min_avg = 99999;
int max_avg = 0;    

void setup() 
{
  size(300,200);
  img = loadImage("glass_beer.png");
  img_stress = loadImage("stress.PNG");
  img_nostress = loadImage("no_stress.PNG");
  
  try
  {
    dsocket = new DatagramSocket(port);
  }
  catch(Exception se){}

  lastTimeSaved = millis();
}

void draw() 
{
  background(255, 255, 255);

  if( ! initializedCanvas)
  {
    initializedCanvas = true;

  }
  else
  {
    try
    {
      dsocket.receive(packet);
    
      // Convert the contents to a string, and display them
      String message = new String(buffer, 0, packet.getLength());
      System.out.println(packet.getAddress().getHostName() + ": " + message);
      
      String[] stringValues = message.split(";");

      int valueChannel0 = Integer.parseInt(stringValues[1]);
  
      System.out.println(valueChannel0);
      
      int total = 0;

      // Calc the total od the sensors values
      for(int i = 1; i<= 4; i++)
      {
        total = total + int(stringValues[i]);
      }
      
      // Calculate each measure of a special port
      total_1 = total_1 + int(stringValues[1]);
      total_2 = total_2 + int(stringValues[2]);
      total_3 = total_3 + int(stringValues[3]);
      total_4 = total_4 + int(stringValues[4]);
      total_5 = total_5 + int(stringValues[5]);
      total_0 = total_0 + int(stringValues[0]);

      // Count the number of loops
      cnt = cnt + 1;
            
      // each 2 seconds
      if(millis() - lastTimeSaved > 2000)
      {

        lastTimeSaved = millis();     
        
        // Calculate each average value of the 2000 calculation per port
        avg_0 = total_0 / cnt;
        avg_1 = total_1 / cnt;
        avg_2 = total_2 / cnt;
        avg_3 = total_3 / cnt;
        avg_4 = total_4 / cnt;
        avg_5 = total_5 / cnt;
        
        // Set new min and max values
        if(avg_0 < min_avg)
        {
           min_avg = avg_0; 
        }
        if(avg_0 > max_avg)
        {
           max_avg = avg_0; 
        }
        
        // Display stress or not
        if(int(avg_0) < 0)
        {
            System.out.println("STRESSED");
            stress();
        }
        else
        {
            System.out.println("CALMED");
            no_stress();
            
        }
      }
      
      
      //Display stress or not
      if(int(avg_0) < 0)
      {
          System.out.println("STRESSED");
          stress();
      }
      else
      {
          System.out.println("CALMED");
          no_stress();
          
      }
      
      
      System.out.println("AVG_0 : " + avg_0);
      System.out.println("min_avg : " + min_avg);
      System.out.println("max_avg : " + max_avg);

    
      // Reset the length of the packet before reusing it.
      packet.setLength(buffer.length);
      
    }catch(Exception e){}
  }
}

// Display Images
void no_stress()
{
  int nextImageWidth = img_nostress.width / currentSizeFactor;
  int imagePositionX = width / 2 - nextImageWidth / 2;
  image(img_stress, imagePositionX, 30, nextImageWidth, img_stress.height / currentSizeFactor);

}

void stress()
{
  if(currentSizeFactor > 1)
  {
    int nextImageWidth = img_stress.width / currentSizeFactor;
    int imagePositionX = width / 2 - nextImageWidth / 2;
    image(img_nostress, imagePositionX, 30, nextImageWidth, img_nostress.height / currentSizeFactor);
  }
}
