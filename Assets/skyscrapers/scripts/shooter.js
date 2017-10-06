



var fireAudioSource : AudioSource;

var fireSound : AudioClip;







var impactprefab : Transform;

var projectilecount : int = 3;
var inaccuracy : float = 0.1;

var force : float = 500;
var damage : float = 50;
var range : float = 100;
var fireRate : float = 0.3;
var  mask : LayerMask;
private var isfiring : boolean = false;
var muzzles : Transform;

function Start()
{
	
	
	muzzles.gameObject.SetActive(false);
	
}
function Update () 
{
	
	
	
	if (Input.GetButton("Fire1"))
	{
		
		dofire();
		muzzles.gameObject.SetActive(true);
		
	}
	else
	{
		muzzles.gameObject.SetActive(false);
	}
	

}

function dofire()
{
 
    if (!isfiring)
    {
        isfiring = true;
       	for(var i : int = 0; i < projectilecount; i++)
       	{
       		fire();
       	}
        
        fireAudioSource.clip = fireSound;
        fireAudioSource.pitch = 0.9 + 0.2*Random.value;
        fireAudioSource.Play();
        yield WaitForSeconds (fireRate);
        fireAudioSource.Stop();
        isfiring = false;
    }
}
function fire()
{

	var rand : Vector2 = Random.insideUnitCircle;
	var fwrd = transform.forward;

    var Up = transform.up;
    var Right = transform.right;
 
    var wantedvector = fwrd;
    wantedvector += Random.Range( -inaccuracy, inaccuracy ) *Up + Random.Range( -inaccuracy, inaccuracy ) * Right;
	var ray = new Ray (transform.position, wantedvector);
	var hit : RaycastHit = new RaycastHit();
	
	if (Physics.Raycast(ray,hit, range,mask))
    {   
      		
      	if(hit.rigidbody) hit.rigidbody.AddForceAtPosition (force * fwrd , hit.point);
      	hit.transform.SendMessageUpwards ("Damage",damage, SendMessageOptions.DontRequireReceiver);
      	var decal = Instantiate(impactprefab, hit.point, Quaternion.FromToRotation(Vector3.up, hit.normal));
      	decal.parent = hit.transform;
    }
}