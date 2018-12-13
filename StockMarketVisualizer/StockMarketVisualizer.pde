// CS5764 TreeMap Homework sample code.
// Make a tree structure out of a categorical csv data table.
// Using the squarified method to visualize stock market prices.
// Written By: Navid Mirmohammadsadeghi

int Canvas_width  = 1800;
int Canvas_height = 800;



String File_Path   = "treemap-stocks.csv";

//Table For_Change = loadTable(File_Path,"header");
//float[] min_change = For_Change.getFloatColumn(6);
//float MIN = min(min_change);
//float MAX = max(min_change);

/*
 *  I had to create every single relationship to build up the hierarchy
    this means that every stock is a child of a subsector, then a sector then a general file
    Covering the whole stock like for example S&P500
 */
ArrayList<String> parent_child = new ArrayList<String>();
Table filling = new Table();
Table Final_Input = new Table();
Table First_layer = new Table();
Table For_Change = new Table();
float MIN;
float MAX;

FinalizedTree FinalizedTree;

void setup(){
  size(1800, 800);
  int canvasWidth  = Canvas_width;
  int canvasHeight = Canvas_height;
  
  Table first = loadTable(File_Path,"header");
  float[] min_change = first.getFloatColumn(6);
  float MIN = min(min_change);
  float MAX = max(min_change);
  
  println(MIN);
  println(MAX);
  
  Table filling2 = new Table();
  Table filling3 = new Table();
  
  //Adding the Total Pattern 

  filling2.setString(1,1,"test");
  filling2.setString(1,2,"test");
  
  /// Creating Some Unique Numbers representing the columns 1 and 2

  
  int Counter = first.getRowCount();
  for(int c=0;c<Counter;c++){
    
  parent_child.add(first.getString(c,2)+"-"+first.getString(c,3));
  filling.setString(c,1,first.getString(c,2));
  filling.setString(c,2,first.getString(c,3));}
  String[] Unique_ones = first.getUnique(1);
  String[] Unique_twos = first.getUnique(2);
  String[] both_uniques = concat(Unique_ones,Unique_twos);
  String[] both_uniques1 = concat(Unique_twos,first.getUnique(3));
  
  println(Unique_ones.length);
  println(Unique_twos.length);
  println(both_uniques.length);
  
  int[] Assigned_Numbers1 = new int[Unique_ones.length];
  int[] Assigned_Numbers2 = new int[Unique_twos.length];
  
  int Shomarande  = 1000;
  int Shomarande1 = 2000;
  for(int u=0;u<Unique_ones.length;u++){
    Shomarande +=1;
    Assigned_Numbers1[u] = Shomarande+1;
    First_layer.setString(u,1,str(9000));
    First_layer.setString(u,2,str(Assigned_Numbers1[u]));
    }
  
  for(int t=0;t<Unique_twos.length;t++){
    Shomarande1 +=1;
    Assigned_Numbers2[t] = Shomarande1+1;}
  
  
  
  int[] Assigned_Numbers3 = new int[Counter];
  for(int cf=0;cf<Counter;cf++){
    Assigned_Numbers3[cf] = first.getInt(cf,0);}
  
  
  int[] Mix_numbers1 = concat(Assigned_Numbers1,Assigned_Numbers2);
  int[] Mix_numbers2 = concat(Assigned_Numbers2,Assigned_Numbers3);
  
  println(Mix_numbers1.length);
  println(filling.matchRowIndex(first.getString(1,1),1));
  IntList Indices = new IntList(); 
 
  for(int C=0;C<Counter;C++){
    if (filling2.matchRowIndex(first.getString(C,1),1)==-1 || filling2.matchRowIndex(first.getString(C,2),2)==-1){
       Indices.append(C);
       filling2.setString(C,1,first.getString(C,1));
       filling2.setString(C,2,first.getString(C,2));
  }
  }
  
  // removing the null cells
  //println(Indices);
  for(int K=0;K<filling2.getRowCount();K++){
    if (Indices.hasValue(K))
      filling3.addRow(filling2.getRow(K));}
  
 
  println(Mix_numbers1[10]);
  
  filling.addRows(filling3);
    //if(parent_child.indexOf(first.getString(c,1)+"-"+first.getString(c,2))==-1){
    //  parent_child.add(first.getString(c,1)+"-"+first.getString(c,2));}
  //// Now that we have the full Vector in terms of Strings we can change them to the Number format
  
  for(int fc=0;fc<filling.getRowCount();fc++){
    for(int fu=0;fu<both_uniques.length;fu++){
      if(filling.getString(fc,1).equals(both_uniques[fu])){
        Final_Input.setString(fc,1,str(Mix_numbers1[fu]));
        break;}
    }}
    
  for(int FC=0;FC<filling.getRowCount();FC++){
    for(int FU=0;FU<both_uniques1.length;FU++){
      if(filling.getString(FC,2).equals(both_uniques1[FU])){
       Final_Input.setString(FC,2,str(Mix_numbers2[FU]));
       break;}
        
      }
      
      
    }
   
   First_layer.addRows(Final_Input);
    

 println(filling.getRowCount());
 //for(int Z=0;Z<628;Z++){
 //  println(Final_Input.getInt(Z,1)+"-"+Final_Input.getInt(Z,2));
 //}
 
 //println(parent_child);
  

  TreeNode root = MakingTree(File_Path);
  
  //println(root.children);
  FinalizedTree = new FinalizedTree(0.0f, 0.0f, (float)canvasWidth, (float)canvasHeight, root);
}

void draw(){
  FinalizedTree.draw();
}

void mouseMoved(){
  FinalizedTree.onMouseMoved(mouseX, mouseY);
}

void mousePressed(){
  FinalizedTree.onMousePressed(mouseX, mouseY, mouseButton);
}

TreeNode MakingTree(String shfFilePath){
  String lines[] = loadStrings(shfFilePath);
  Table     Data = loadTable(File_Path,"header");
  //println(Data.getInt(402,5));
  int numberOfLeaves   = floor(Data.getRowCount()/1);
  //int numberOfLeaves = int(lines[0]);
  int start = 0;
  int end = numberOfLeaves;
  ArrayList<TreeNode> TreeNodes = new ArrayList<TreeNode>();
  for(int i = start; i < end; i++){
    String[] data = split(lines[i], ",");
    //println(lines[i]);
    int id = Data.getInt(i,0);
    int value = Data.getInt(i,5);
    String name = Data.getString(i,3);
    float change = Data.getFloat(i,6);
    String full_name = Data.getString(i,4);
    String sub_sector = Data.getString(i,2);
    String sector     = Data.getString(i,1);
    TreeNode leaf = new TreeNode(id, value,name,change,full_name,sub_sector,sector);
    TreeNodes.add(leaf);
  }
  //for(int k=0;k<TreeNodes.size();k++){
  //println(TreeNodes.get(k));}
  //println(TreeNodes);
  int numberOfRelationShips = numberOfLeaves;
  start = 0;
  end   = filling.getRowCount();
  for(int j = start; j < end; j++){
    //String[] data = split(parent_child.get(j), "-");
    //println(data);
    int parentID = First_layer.getInt(j,1);
    int childID  = First_layer.getInt(j,2);
    TreeNode parent = null;
    TreeNode child = null;
    //println(TreeNodes.size());
    for(int k = 0; k < TreeNodes.size(); k++){
      TreeNode TreeNode = TreeNodes.get(k);
      //println(TreeNode.getID()+"-"+parentID+"-"+parent);
      if(parent == null && TreeNode.getID()==parentID)
        parent = TreeNode;
        //println(1);
      else if(child == null && TreeNode.getID()==childID)
        child = TreeNode;
      if(parent != null && child != null)
        break;
    }
    if(parent == null){
      parent = new TreeNode(parentID, 0,"",0,"","","");
      TreeNodes.add(parent);
      //println(j);
      //println(parentID+"-"+childID);
    }
    if(child == null){
      child = new TreeNode(childID, 0,"",0,"","","");
      TreeNodes.add(child);
      //println(2);
      //println(childID);
    }
    child.set(parent);
    parent.add(child);
  }
  //println(TreeNodes);
  //println(TreeNodes.get(383));
  TreeNode root = null;
  for(int k = 0; k < TreeNodes.size(); k++){
    TreeNode TreeNode = TreeNodes.get(k);
    if(TreeNode.isRoot()){
      root = TreeNode;
      break;
    }
  }
  return root;
}

/////// Squarify Code


public class FinalizedTree extends Visualizer{

  private static final float OFFSET_DEFAULT = 2.0f;

  private float offset;
  private TreeNode root;
  private TreeNode viewRoot;

  public FinalizedTree(float viewX, float viewY, float viewWidth, float viewHeight, TreeNode root){
    this(viewX, viewY, viewWidth, viewHeight, root, OFFSET_DEFAULT);
  }

  public FinalizedTree(float viewX, float viewY, float viewWidth, float viewHeight, TreeNode root, float offset){
    super(viewX, viewY, viewWidth, viewHeight);
    this.offset = offset;
    this.root = root;
    this.viewRoot = null;
    this.switchViewRootTo(this.root);
  }

  private void switchViewRootTo(TreeNode TreeNode){
    if(this.viewRoot != null)
      this.dehighlight(this.viewRoot);
    this.viewRoot = TreeNode;
    this.viewRoot.set(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    this.squarify(this.viewRoot);
  }

  private void squarify(TreeNode TreeNode){
    if(!TreeNode.isLeaf()){
      float canvasX = TreeNode.getX() + this.offset;
      float canvasY = TreeNode.getY() + this.offset;
      float canvasWidth = TreeNode.getWidth() - (this.offset * 2.0f);
      float canvasHeight = TreeNode.getHeight() - (this.offset * 2.0f);

      float canvasArea = canvasWidth * canvasHeight;
      float vaRatio = canvasArea / (float)TreeNode.getValue();

      int i = 0;
      while(i < TreeNode.getNumberOfChildren()){
        float shorterSide;
        if(canvasWidth < canvasHeight)
          shorterSide = canvasWidth;
        else
          shorterSide = canvasHeight;

        float value = (float)TreeNode.getChildAt(i).getValue();
        float anotherSideC1 = value * vaRatio / shorterSide;
        float aspectRatioC1;
        if(anotherSideC1 < shorterSide)
          aspectRatioC1 = shorterSide / anotherSideC1;
        else
          aspectRatioC1 =  anotherSideC1 / shorterSide;
        if(i + 1 == TreeNode.getNumberOfChildren()){
          TreeNode child = TreeNode.getChildAt(i);
          child.set(canvasX, canvasY, canvasWidth, canvasHeight);
          i++;
        }
        for(int j = i + 1; j < TreeNode.getNumberOfChildren(); j++){
          float c2Value = (float)TreeNode.getChildAt(j).getValue();
          float sumOfValue = value + c2Value;
          float anotherSideC2 = sumOfValue * vaRatio / shorterSide;
          float aspectRatioC2;
          if(anotherSideC2 < (shorterSide * (c2Value / sumOfValue)))
             aspectRatioC2 = (shorterSide * (c2Value / sumOfValue)) / anotherSideC2;
          else
             aspectRatioC2 = anotherSideC2 / (shorterSide * (c2Value / sumOfValue));
          if(aspectRatioC2 < aspectRatioC1){
            aspectRatioC1 = aspectRatioC2;
            anotherSideC1 = anotherSideC2;
            value = sumOfValue;
          }else{
            float x = canvasX;
            float y = canvasY;
            for(int k = i; k < j; k++){
              TreeNode child = TreeNode.getChildAt(k);
              child.setX(x);
              child.setY(y);
              float childValue = (float)child.getValue();
              if(canvasWidth < canvasHeight){
                child.setWidth(shorterSide * (childValue / value));
                child.setHeight(anotherSideC1);
                x += shorterSide * (childValue / value);
              }else{
                child.setWidth(anotherSideC1);
                child.setHeight(shorterSide * (childValue / value));
                y += shorterSide * (childValue / value);
              }
            }
            i = j;
            if(canvasWidth < canvasHeight){
              canvasY += anotherSideC1;
              canvasHeight -= anotherSideC1;
            }else{
              canvasX += anotherSideC1;
              canvasWidth -= anotherSideC1;
            }
            break;
          }
        }
      }

      for(int n = 0; n < TreeNode.getNumberOfChildren(); n++)
        this.squarify(TreeNode.getChildAt(n));
    }
  }

  public void draw(){
    this.viewRoot.draw(this.offset);  
  }

  public void onMouseMoved(int toX, int toY){
    this.tryToHiglight(this.viewRoot, toX, toY);
  }

  public void onMousePressed(int onX, int onY, int mouseButtonType){
    if(mouseButtonType == LEFT)
      zoomIn(mouseX, mouseY);
    else if(mouseButtonType == RIGHT)
      zoomOut();
  }

  private void dehighlight(TreeNode TreeNode){
    TreeNode.dehighlight();
    for(int i = 0; i < TreeNode.getNumberOfChildren(); i++)
      this.dehighlight(TreeNode.getChildAt(i));
  }
  private void tryToHiglight(TreeNode TreeNode, int x, int y){
    if(TreeNode.isIntersectingWith(x, y)){
      if(TreeNode.isLeaf())
        TreeNode.highlight();
      else
        TreeNode.dehighlight();
      for(int i = 0; i < TreeNode.getNumberOfChildren(); i++)
        this.tryToHiglight(TreeNode.getChildAt(i), x, y);
    }else{
      this.dehighlight(TreeNode);
    }
  }

  private void zoomIn(int x, int y){
    for(int i = 0; i < this.viewRoot.getNumberOfChildren(); i++){
      TreeNode child = this.viewRoot.getChildAt(i);
      if(child.isIntersectingWith(x, y)){
        this.switchViewRootTo(child);
        break;
      }
    }
  }
  private void zoomOut(){
    if(this.viewRoot != this.root)
      this.switchViewRootTo(this.viewRoot.getParent());
  }

}

////// Public Class TreeNode For reading the TreeNode parent situation, the class should get the change in percentile
////// and other parameters like name and other stuff.


public class TreeNode extends Visualizer{

  private int id;
  private int value;
  private String name;
  private float  change;
  private String full_name;
  private String sub_sector;
  private String sector;
  private TreeNode parent;
  private ArrayList<TreeNode> children;
  int a=0;

  public TreeNode(int id, int value,String name,float change,String full_name,String sub_sector,String sector){
    super();
    this.id = id;
    this.value = value;
    this.name = name;
    this.change = change;
    this.full_name = full_name;
    this.sub_sector = sub_sector;
    this.sector = sector;
    this.parent = null;
    this.children = new ArrayList<TreeNode>();
  }

  public int getID(){
    return this.id;
  }
  
  public String getName(){
    return this.name;
  }
  
  public float getChange(){
    return this.change;
  }
  
  public String getFullName(){
    return this.full_name;
  }
  
  public String getSubSector(){
    return this.sub_sector;
  }
  
  public String getSector(){
    return this.sector;
  }
  
  public int getValue(){
    return this.value;
  }

  public void set(TreeNode parent){
    this.parent = parent;
  }
  public TreeNode getParent(){
    return this.parent;
  }

  public boolean isRoot(){
    if(this.parent == null)
      return true;
    else
      return false;
  }
  public boolean isLeaf(){
    if(this.children.isEmpty())
      return true;
    else
      return false;
  }

  public int getNumberOfChildren(){
    return this.children.size();
  }
  public TreeNode getChildAt(int index){
    return this.children.get(index);
  }
  public void add(TreeNode child){
    this.children.add(child);
    this.update();
    if(!this.isRoot())
      this.parent.notifyValueUpdated();
  }
  private void update(){
    int value = 0;
    for(int i = 0; i < this.children.size(); i++)
      value += this.children.get(i).getValue();
    this.value = value;
    //sort children in descending order of value
    ArrayList<TreeNode> children = new ArrayList<TreeNode>();
    while(!this.children.isEmpty()){
      TreeNode max = this.children.get(0);
      for(int i = 1; i < this.children.size(); i++){
        TreeNode target = this.children.get(i);
        if(target.getValue() > max.getValue())
          max = target;
      }
      children.add(max);
      this.children.remove(max);
    }
    this.children = children;
  }
  public void notifyValueUpdated(){
    this.update();
    if(!this.isRoot())
      this.parent.notifyValueUpdated();
  }

  public void draw(float offset){
    float c=0.0;
    int S = 0;
    TreeNode X1 = this.getParent();
    noFill();
    c = map(this.getChange(),-12,11,20,100);
    //noFill();
    if(this.MouseOver()){
        //stroke(15, 100, 100, 100);}
      fill(255);
      S =1;
    }  
    else if(this.getChange()>0 && this.getChange()<1)
       fill(0,150,0);
    else if(this.getChange()>1 && this.getChange()<2)
       fill(0,200,0);
    else if(this.getChange()>2 && this.getChange()<11)
       fill(0,255,0);
    else if(this.getChange()<0 && this.getChange()>-1)
       fill(150,0,0);
    else if(this.getChange()>-2 && this.getChange()<-1)
       fill(200,0,0);
    else if(this.getChange()>-13 && this.getChange()<-2)
       fill(255,0,0);
    else
       fill(255);
    
    rect(this.getX() + offset, this.getY() + offset, this.getWidth() - (2.0f * offset), this.getHeight() - (2.0f * offset));
    
    textSize(20);
    textAlign(CENTER, CENTER);
    if(this.MouseOver()){
      fill(255);
      }
    else
      fill(0);
    
    text(this.getName(), this.getCenterX(), this.getCenterY());
    
    if(this.MouseOver()){
      //fill(0);
      //println(this.getParent());
        fill(255);
        rect(this.getX() + offset,this.getY() + offset,this.getWidth()- (2.0f * offset) , this.getHeight()- (2.0f * offset));
        fill(0);
        textSize(16);
        text(this.getChange(),mouseX+20,mouseY+20);
        text(this.getFullName(),mouseX+20,mouseY+40);
        text(this.getSubSector(),mouseX+20,mouseY+60);
        text(this.getSector(),mouseX+20,mouseY+80);}
    
      //rect(mouseX-10,mouseY+80,200,100);
      
     //popMatrix();
    //text(this.getChange(), this.getCenterX(), this.getCenterY()+20);
    for(int i = 0; i < this.getNumberOfChildren(); i++)
      this.getChildAt(i).draw(offset);
    

  }

  
  public String toString(){
    int parentID = -1; //ad-hoc
    if(!this.isRoot())
      parentID = this.getParent().getID();
    String childrenIDs = "[";
    for(int i = 0 ; i < this.children.size(); i++)
      childrenIDs += this.children.get(i).getID() + " ";
    childrenIDs += "]";
    return "ID:"          + this.id     + "," +
           "VALUE:"       + this.value  + "," +
           "PARENT_ID:"   + parentID    + "," +
           "CHILDREN_IDS" + childrenIDs;
  }
  public void printTree(){
    println(this.toString());
    for(int i = 0; i < this.children.size(); i++)
      this.children.get(i).printTree();
  }

}


///// Public Class Visualizer is important in updating the positions on the screen


public class Visualizer{

  protected float viewX;
  protected float viewY;
  protected float viewWidth;
  protected float viewHeight;
  protected float viewCenterX;
  protected float viewCenterY;
  protected boolean MouseOver;

  public Visualizer(){
    this(-1.0f, -1.0f, -1.0f, -1.0f); //ad-hoc
  }
  public Visualizer(float viewX, float viewY, float viewWidth, float viewHeight){
    this.set(viewX, viewY, viewWidth, viewHeight);
    this.dehighlight();
  }

  public void set(float viewX, float viewY, float viewWidth, float viewHeight){
    this.viewX = viewX;
    this.viewY = viewY;
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
    this.updateCenter();
  }
  public void setX(float viewX){
    this.viewX = viewX;
    this.updateCenter();
  }
  public void setY(float viewY){
    this.viewY = viewY;
    this.updateCenter();
  }
  public void setWidth(float viewWidth){
    this.viewWidth = viewWidth;
    this.updateCenter();
  }
  public void setHeight(float viewHeight){
    this.viewHeight = viewHeight;
    this.updateCenter();
  }
  private void updateCenter(){
    this.viewCenterX = this.viewX + this.viewWidth / 2.0f;
    this.viewCenterY = this.viewY + this.viewHeight / 2.0f;
  }
  public void highlight(){
    this.MouseOver = true;
  }
  public void dehighlight(){
    this.MouseOver = false;
  }

  public float getX(){
    return this.viewX;
  }
  public float getY(){
    return this.viewY;
  }
  public float getWidth(){
    return this.viewWidth;
  }
  public float getHeight(){
    return this.viewHeight;
  }
  public float getCenterX(){
    return this.viewCenterX;
  }
  public float getCenterY(){
    return this.viewCenterY;
  }
  public boolean MouseOver(){
    return this.MouseOver;
  }
  public boolean isIntersectingWith(int x, int y){
    if(this.viewX <= x && x <= this.viewX + this.viewWidth){
      if(this.viewY <= y && y <= this.viewY + this.viewHeight)
        return true;
      else
        return false;
    }else{
      return false;
    }
  }

}

/////
