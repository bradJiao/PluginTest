﻿using UnityEngine;
using System.Collections;

public class Test : MonoBehaviour
{

		// Use this for initialization
		void Start ()
		{
				index = 0;
		}

		string[] test_beacons = {
		"00000000-0000-0000-0000-000000000000,0,0,3,-36,0.111773;00000000-0000-0000-0000-000000000000,1,1,2,-66,3.099437;00000000-0000-0000-0000-000000000000,1,2,1,-59,1.931947;00000000-0000-0000-0000-000000000000,1,0,1,-72,3.950171;00000000-0000-0000-0000-000000000000,1,3,1,-80,9.153944;00000000-0000-0000-0000-000000000000,1,4,1,-76,12.901476;",
		"00000000-0000-0000-0000-000000000000,0,0,3,-43,0.216064;00000000-0000-0000-0000-000000000000,1,0,2,-67,3.071049;00000000-0000-0000-0000-000000000000,1,1,2,-69,3.449602;00000000-0000-0000-0000-000000000000,1,2,1,-69,4.084239;00000000-0000-0000-0000-000000000000,1,3,1,-70,4.641589;00000000-0000-0000-0000-000000000000,1,4,1,-79,14.677993;",
		"00000000-0000-0000-0000-000000000000,0,0,3,-36,0.094245;00000000-0000-0000-0000-000000000000,1,2,2,-61,1.743332;00000000-0000-0000-0000-000000000000,1,1,2,-64,2.691604;00000000-0000-0000-0000-000000000000,1,0,1,-68,3.823684;00000000-0000-0000-0000-000000000000,1,3,1,-71,7.023537;00000000-0000-0000-0000-000000000000,1,4,1,-72,10.148783;",
		"100000000-0000-0000-0000-000000000000,0,0,3,-36,0.089671;00000000-0000-0000-0000-000000000000,1,2,2,-62,1.719542;00000000-0000-0000-0000-000000000000,1,1,2,-64,2.509518;00000000-0000-0000-0000-000000000000,1,0,1,-70,4.018434;00000000-0000-0000-0000-000000000000,1,3,1,-72,6.674987;00000000-0000-0000-0000-000000000000,1,4,1,-69,7.809734;",
		"00000000-0000-0000-0000-000000000000,0,0,3,-36,0.089671;00000000-0000-0000-0000-000000000000,1,2,2,-62,1.719542;00000000-0000-0000-0000-000000000000,1,1,2,-64,2.509518;00000000-0000-0000-0000-000000000000,1,0,1,-70,4.018434;00000000-0000-0000-0000-000000000000,1,3,1,-72,6.674987;00000000-0000-0000-0000-000000000000,1,4,1,-69,7.809734;",
		"00000000-0000-0000-0000-000000000000,0,0,3,-39,0.108320;00000000-0000-0000-0000-000000000000,1,2,2,-65,1.978381;00000000-0000-0000-0000-000000000000,1,1,2,-63,2.213537;00000000-0000-0000-0000-000000000000,1,0,1,-68,3.633565;00000000-0000-0000-0000-000000000000,1,3,1,-75,7.059258;00000000-0000-0000-0000-000000000000,1,4,1,-72,7.303889;",
		"1111-11111-1111,0,0,1,-56,3.1;0000-00000-00000,1,1,2,-7,1.1",
		"1111-11111-1111,0,0,1,-35,3.1;0000-00000-00000,1,1,2,-8,1.1",
		"1111-11111-1111,0,0,1,-44,3.1;0000-00000-00000,1,1,2,-9,1.1",
		"1111-11111-1111,0,0,1,-66,3.1;0000-00000-00000,1,1,2,-3,1.1"};
		int index;
		int count = 1000;
		// Update is called once per frame
		void Update ()
		{

				if (count > 0) {
						count --;

						iBeaconReceiver[] receiver = GetComponentsInParent<iBeaconReceiver> ();
						receiver [0].RangeBeacons (test_beacons [1]);

						if (index >= 6) {
								index = 0;
						}

				} else {
						iBeaconReceiver[] receiver = GetComponentsInParent<iBeaconReceiver> ();
						receiver [0].RangeBeacons ("");
				}
		}
}