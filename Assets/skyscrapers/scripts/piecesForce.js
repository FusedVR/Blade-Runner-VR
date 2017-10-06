var radius = 5.0;
var power = 10.0;

function Start () 
{

var explosionPos : Vector3 = transform.position;
var colliders : Collider[] = Physics.OverlapSphere (explosionPos, radius);
Destroy (gameObject, 10);		
for (var hit : Collider in colliders)
{
	if (hit && hit.GetComponent.<Rigidbody>())
	
		
		
		hit.GetComponent.<Rigidbody>().AddExplosionForce(power, explosionPos, radius, 3.0);
		
		
	}
}