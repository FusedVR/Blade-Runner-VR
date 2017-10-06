var radius = 5.0;
var power = 10.0;
var damage : float = 50;
function Start () 
{
// Applies an explosion force to all nearby rigidbodies
var explosionPos : Vector3 = transform.position;
var colliders : Collider[] = Physics.OverlapSphere (explosionPos, radius);
Destroy (gameObject, 5);		
for (var hit : Collider in colliders)
{
	if (hit && hit.GetComponent.<Rigidbody>())
	
		
		
		hit.GetComponent.<Rigidbody>().AddExplosionForce(power, explosionPos, radius, 3.0);
		
		hit.SendMessage ("Damage", damage,SendMessageOptions.DontRequireReceiver);
	}
}