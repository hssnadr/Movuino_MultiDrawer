public class Point {
  public float x;
  public float y;

  private float _timeLife = -1; // -1 stand for infinite life
  private long _timerLife0;

  public Point(float x_, float y_) {
    this.x = x_;
    this.y = y_;
  }

  public Point(float x_, float y_, float lifeTime_) {
    this.x = x_;
    this.y = y_;
    this._timeLife = lifeTime_;
    this._timerLife0 = millis();
  }

  //---------------------------
  //--------- GETTERS ---------
  //---------------------------
  public PVector getPoint() {
    return new PVector(this.x, this.y);
  }
  
  public boolean isAlive() {
    if(this._timeLife > 0) {
      println(millis() - this._timerLife0 < this._timeLife);
      return millis() - this._timerLife0 < this._timeLife;
    } else {
      return true;
    }
    
  }

  //---------------------------
  //--------- METHODS ---------
  //---------------------------
  public void draw() {
    point(this.x, this.y); // not used here
  }
}
