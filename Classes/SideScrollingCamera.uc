class SideScrollingCamera extends Camera;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    `Log("Custom Camera up");
}

/*****************************************************************
 *
 *  TUTORIAL FUNCTION
 *
 *  This function was extended from camera. Your pawn will request
 *  a camera type when its created with function GetDefaultCameraMode,
 *  Force it to 'SideScrolling'. This change is small and doesnt hinder the
 *  in-game use of other buil-in camera types.
 *
 *  This is a skeletal function provided to be simple and to the point
 *  to get an iso camera, add more or extend from another parent class
 *  if you miss anything from GameCamera.
 *
 *
 *****************************************************************/

 function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
 {
    local vector Loc, Pos, HitLocation, HitNormal;
    local rotator Rot;
    local Actor HitActor;
    local CameraActor CamActor;
    local bool bDoNotApplyModifiers;
    local TPOV OrigPOV;
    
    //store old POV
    OrigPOV = OutVT.POV;
    
    //Default FOV on viewtarget
    OutVT.POV.FOV = DefaultFOV;
    
    //Viewing through camera actor
    CamActor = CameraActor(OutVT.Target);
    if (CamActor != None)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        
        //Get aspect ration from cam actor
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;
        
        //Check if CamActor tries to override current PostProcess settings
        CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
        CamPostProcessSettings = CamActor.CamOverridePostProcess;
    }
    else
    {
        //Give Pawn Viewtarget chance to dictate camera, else set own defaults
        if(Pawn(OutVT.Target)==None || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
        {
            //Don't use modifiers when using debug cam mode
            bDoNotApplyModifiers = TRUE;
            
            switch(CameraStyle)
            {
                case 'Fixed' :
                OutVT.POV = OrigPOV;
                break;
                
                case 'ThirdPerson' :
                case 'FreeCam' :
                case 'FreeCam_Default' :
                Loc = OutVT.Target.Location;
                Rot = OutVT.Target.Rotation;
                
                if(CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default')
                {
                    Rot = PCOwner.Rotation;
                }
                Loc += FreeCamOffset >> Rot;
                
                Pos = Loc - Vector(Rot) * FreeCamDistance;
                
                HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12));
                OutVT.POV.Location = (HitActor == None) ? Pos: HitLocation;
                OutVT.POV.Rotation = Rot;
                
                break;
                
                case 'SideScrolling' :
                
                //Fix cam rot, yaw will rotate cam
                Rot.Pitch = (0.0f *DegToRad) * RadToUnrRot;
                Rot.Roll = (0 * DegToRad) * RadToUnrRot;
                Rot.Yaw = (-90.0f * DegToRad) * RadToUnrRot;
                
                //fix camera position offset from the avatar. Location.X sets character start on left or right side of screen.
                
                //Negative number puts them on right, positive number on left.
                //Location.Y is zoom to character. Closer to 0 = more zoom
                
                Loc.X = PCOwner.Pawn.Location.X + 100;
                Loc.Y = PCOwner.Pawn.Location.Y + 200;
                Loc.Z = PCOwner.Pawn.Location.Z + 0;
                
                //Set zooming
                Pos = Loc - Vector(Rot) * FreeCamDistance;
                
                OutVT.POV.Location = Pos;
                OutVT.Pov.Rotation = Rot;
                
                break;
                
                case 'FirstPerson' : //First person view
                
                default :
                OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
                break;
            }
        }
    }
    
    if(!bDoNotApplyModifiers)
    {
        //Apply cam mods at the end
        ApplyCameraModifiers(DeltaTime, OutVT.POV);
    }
    //`log(WorldInfo.TimeSeconds @ GetFuncName() @ OutVT.Target @ OutVT.POV.Location @ OutVT.POV.Rotation @ OutVT.POV.FOV);
 }
 
 DefaultProperties
 {
    DefaultFOV=90.f
 }