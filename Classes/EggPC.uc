class EggPC extends GamePlayerController;

Var EggActor    PlayerEgg;
Var Bool    MoveUpIsPressed, MoveDownIsPressed, MoveLeftIsPressed, MoveRightIsPressed;

simulated event PostBeginPlay()
{
    PlayerEgg = Spawn(class'EggActor', self,,Location);
    `Log("[EggPC] PostBeginPlay has completed");
    
    
    
    
}

exec Function MoveEgg(int Sideways, int Forward)
{
    `Log("Move Function");
    //PlayerEgg.MyVel.X=Sideways*400;
    PlayerEgg.MyVel.Y=Forward*400;
}

simulated exec Function MoveF()
{
    PlayerEgg.MyVel.Y=400;
	PlayerEgg.MyVel.Z=300;
}

simulated exec Function StopMove()
{
    PlayerEgg.MyVel.Y=100;
}



DefaultProperties
{
	CameraClass=class'SideScrollingCamera'
}