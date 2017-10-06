using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Being : MonoBehaviour {

    private void OnTriggerEnter(Collider other) {
        if (other.tag == "Player") {
            //play an animation
            Destroy(this.gameObject);
        }
    }


}
