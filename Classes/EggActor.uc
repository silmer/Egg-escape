class EggActor extends KActorSpawnable
placeable;

var vector MyVel;

function tick(float deltatime)
{ 
    local Vector L;
    StaticMeshComponent.SetRBLinearVelocity(MyVel*deltatime, true);
    
    L=StaticMeshComponent.GetPosition();
    //L+=vect(-1,0,1)*200;
    L+=vect(-500,0,0);
    
    Owner.SetLocation(L);
    
    Owner.setrotation(rotator(StaticMeshcomponent.getposition() - L) );
    //Owner.setRotation(rotator(vect(-1,0,0)));
    
}

simulated event PostBeginPlay()
{
    local RB_ConstraintActor TwoDConstraint;
    super.PostBeginPlay();
    
    //Spawn constraint
    TwoDConstraint.Spawn(class'RB_ConstraintActorSpawnable', self, '', Location, rot(0,0,0));
    
    //bLimited to 0 for Y and Z to allow movement
    TwoDConstraint.ConstraintSetUp.LinearYSetup.bLimited = 0;
    TwoDConstraint.ConstraintSetup.LinearZSetup.bLimited = 0;
    
    //Force the actor to not swing to X
    TwoDConstraint.ConstraintSetup.bSwingLimited=true;
    
    //Initialize constraint
    TwoDConstraint.InitConstraint(self, None);
    
}

defaultproperties
{
    Begin Object Name=StaticMeshComponent0
    StaticMesh=StaticMesh'egg_escape.egg'
    End object
    
    bWakeOnLevelStart=true
    
    // bEnableStayUprightSpring = true
    // StayUprightTorqueFactor = 1
}