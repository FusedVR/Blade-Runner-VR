#pragma strict

var boostparticle : Transform;
var maxVelocityChange = 10.0;
public var speed : float = 4;
var explosion : Transform;
var pieces : Transform;
var smoothSpeed : float = 2;
private var sensitivityX : float = 6;
private var meshturn : float;
private var rotationX : float = 0;
private var rotationY : float = 0;
public var rotateSpeed : float = 8.0;
public var dampTime : float = 3;
public var mask : LayerMask;
var sensitivity : float ;
var myaudiosource : AudioSource;
private var boost : float = 36;
var velocityChange : Vector3;
var planemesh : Transform;
private var originalmeshrotation : Quaternion;
private var meshRotation : Quaternion;
private var addspeed : float;

private var forward : Vector3 = Vector3.forward;
private var moveDirection : Vector3 = Vector3.zero;
private var right : Vector3;




function Awake()
{
 	GetComponent.<Rigidbody>().freezeRotation = true;
	GetComponent.<Rigidbody>().useGravity = false;
    
}
function Start()
{
    originalmeshrotation = planemesh.localRotation;
    
}
function FixedUpdate()
{
 	var cameraTransform = GetComponent.<Camera>().main.transform; 
 	forward = transform.TransformDirection(Vector3.forward);
 	
	var right = new Vector3(forward.z, 0, -forward.x);
	var hor = Input.GetAxis("Horizontal");
	var ver = Input.GetAxis("Vertical");
	if (Input.GetButton("Jump"))
	{
		addspeed = boost;
		boostparticle.gameObject.SetActive(true);
	}
	else
	{
		addspeed = 0;
		boostparticle.gameObject.SetActive(false);
	}
	ver = Mathf.Clamp(ver ,0,1);
	
	var targetDirection =  forward * (speed + addspeed);
	
	
	
	var targetVelocity = targetDirection;
	
	var velocity = GetComponent.<Rigidbody>().velocity;
	
	rotationY += Input.GetAxis("Mouse Y") * sensitivity;
	rotationX += Input.GetAxis("Mouse X") * sensitivity;
	
	
	var myQuaternion : Quaternion = Quaternion.Euler(-rotationY,rotationX,0);
	
	transform.localRotation = Quaternion.Slerp(transform.localRotation,myQuaternion, Time.deltaTime * smoothSpeed);
	if (Input.GetAxis("Mouse X") != 0)
	{
		meshturn += Input.GetAxis("Mouse X") * sensitivity;
		var meshQuaternion : Quaternion =  Quaternion.Euler(0,0, - meshturn);
		planemesh.transform.localRotation = Quaternion.Slerp(planemesh.transform.localRotation,meshQuaternion, Time.deltaTime * 2);
	}
	else
	{
		meshturn = 0;
		planemesh.transform.localRotation = Quaternion.Slerp(planemesh.transform.localRotation,originalmeshrotation, Time.deltaTime * 2);
	}
	
	var currentpitchx = Mathf.Abs(Input.GetAxis("Mouse X"));
	var currentpitchy = Mathf.Abs(Input.GetAxis("Mouse Y"));
	myaudiosource.pitch = Mathf.Lerp(myaudiosource.pitch,(0.9 + (addspeed /28) + ((currentpitchx *1.8 ) + (currentpitchy * 1.6))), Time.deltaTime * 2);
	
	
	velocityChange = (targetVelocity - velocity);
	
	velocityChange.x = Mathf.Clamp(velocityChange.x, -maxVelocityChange, maxVelocityChange);
	velocityChange.z = Mathf.Clamp(velocityChange.z, -maxVelocityChange, maxVelocityChange);
	velocityChange.y = Mathf.Clamp(velocityChange.y, -maxVelocityChange, maxVelocityChange);
	GetComponent.<Rigidbody>().AddForce(velocityChange, ForceMode.VelocityChange);
	 	
}     
function OnCollisionEnter(collision : Collision)
{
		
		var contact : ContactPoint = collision.contacts[0];
		var rot : Quaternion = Quaternion.FromToRotation(Vector3.up, contact.normal);
		var pos : Vector3 = contact.point;
		Instantiate(explosion, pos, rot);
		Instantiate(pieces, pos, rot);
		var gamecontroller = GameObject.FindWithTag ("GameController");
		gamecontroller.BroadcastMessage("GameOver");
		Destroy(gameObject);
	}
