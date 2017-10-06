using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class SpawnEnemy : MonoBehaviour {
    public GameObject player;

    public Transform[] SpawnPoints;

    public NavMeshAgent[] agentPrefabs;

	// Use this for initialization
	IEnumerator Start () {
	    while (true) {
            Transform point = SpawnPoints[Random.Range(0, SpawnPoints.Length)];
            NavMeshHit pos;
            NavMesh.SamplePosition(point.position, out pos, float.MaxValue, 1);
           
            NavMeshAgent a = Instantiate ( agentPrefabs[Random.Range(0, agentPrefabs.Length)], 
                pos.position, Quaternion.LookRotation(player.transform.position - pos.position, Vector3.up)
                );
            a.SetDestination( player.transform.position );

            yield return new WaitForSeconds(Random.Range(2f, 4f));
        }	
	}
}
