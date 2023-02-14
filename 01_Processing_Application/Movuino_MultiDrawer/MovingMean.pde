public class MovingMean {
  private int _N = 2;
  private FloatList _dataCollection;
  
  //---------------------------
  //------ CONSTRUCTORS -------
  //---------------------------
  
  public MovingMean() {
    this._dataCollection = new FloatList();
  }
  
  public MovingMean(int n) {
    this._N = n;
    this._dataCollection = new FloatList();
  }
  
  //---------------------------
  //--------- SETTERS ---------
  //---------------------------
  
  public void setSmooth(int n_) {
    this._N = n_;
  }
  
  //---------------------------
  //--------- GETTERS ---------
  //---------------------------
  
  public float getSmooth(){
    int mean_ = 0;
    for(int i=0; i < this._dataCollection.size(); i++){
      mean_ += this._dataCollection.get(i);
    }
    return mean_ / float(this._dataCollection.size());
  }
  
  //---------------------------
  //--------- METHODS ---------
  //---------------------------
  
  public void pushData(float data_){
    // 1 - add new raw value
    this._dataCollection.append(data_);
    
    // 2 - remove older _dataCollection from the list
    while(this._dataCollection.size() > this._N){
      this._dataCollection.remove(0);
    }
  }
}
