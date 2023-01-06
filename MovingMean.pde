public class MovingMean {
  private int N = 2;
  private FloatList dataCollection;
  
  public MovingMean(int n) {
    N = n;
    this.dataCollection = new FloatList();
  }
  
  public void pushData(float data_){
    // 1 - add new raw value
    this.dataCollection.append(data_);
    
    // 2 - remove older dataCollection from the list
    while(this.dataCollection.size() > N){
      this.dataCollection.remove(0);
    }
  }
  
  private float getSmooth(){
    int mean_ = 0;
    for(int i=0; i < this.dataCollection.size(); i++){
      mean_ += this.dataCollection.get(i);
    }
    return mean_ / float(this.dataCollection.size());
  }
}
