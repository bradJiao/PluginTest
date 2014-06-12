using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class iBeaconReceiverExample : MonoBehaviour
{
		private Vector2 scrolldistance;
		private List<Beacon> mybeacons = new List<Beacon> ();
//		private bool scanning = true;
		// Use this for initialization
		void Start ()
		{
				iBeaconReceiver.Init ();
				if (iBeaconReceiver.is_device_init_ok) {
						iBeaconReceiver.BeaconRangeChangedEvent += OnBeaconRangeChanged;
						iBeaconReceiver.BeaconArrivedEvent += OnBeaconArrived;
						iBeaconReceiver.BeaconOutOfRangeEvent += OnBeaconOutOfRange;
						iBeaconReceiver.Scan();
						Debug.Log ("Listening for beacons");
				} else {
						Debug.Log ("init device fail");
				}
		}
	
		void OnDestroy ()
		{
				iBeaconReceiver.BeaconRangeChangedEvent -= OnBeaconRangeChanged;
				iBeaconReceiver.BeaconArrivedEvent -= OnBeaconArrived;
				iBeaconReceiver.BeaconOutOfRangeEvent -= OnBeaconOutOfRange;
				iBeaconReceiver.Stop ();
		}

		private void OnBeaconArrived (Beacon beacon)
		{
				Debug.Log ("Beacon arrived: " + beacon.ToString ());
		}

		private void OnBeaconOutOfRange (Beacon beacon)
		{
				Debug.Log ("Beacon out of range: " + beacon.ToString ());
		}

		private void OnBeaconRangeChanged (List<Beacon> beacons)
		{
				mybeacons = beacons;
		}

		//int count = 1000;

		void Update ()
		{
				if (!iBeaconReceiver.is_device_init_ok) {
						return;
				}
				//for test
//				if (count > 0) {
//						count --;
//						var test_beacon = new Beacon ();
//						test_beacon.UUID = "11111-1111-11111";
//						test_beacon.major = 1;
//						test_beacon.minor = 1;
//						mybeacons = new List<Beacon> (){test_beacon};
//				} else {
//						mybeacons = new List<Beacon> ();
//				}
				//for test end

				foreach (var b in mybeacons) {
						string bs_tag = "bs-" + b.major + "-" + b.minor;
						try {
								GameObject bs_obj = GameObject.FindGameObjectWithTag (bs_tag);
								if (null != bs_obj) {
										iBeaconBS bs_script = bs_obj.GetComponent<iBeaconBS> ();
										bs_script.setBeacon (b);
								} else {
										//Debug.Log ("No this BeaconBS:" + b.major + "-" + b.minor);
								}
				
						} catch (System.Exception ex) {
				
						}
						
				}
		}
	
//	void OnGUI() {
//		GUIStyle labelStyle = GUI.skin.GetStyle("Label");
//#if UNITY_ANDROID
//		labelStyle.fontSize = 40;
//#elif UNITY_IOS
//		labelStyle.fontSize = 25;
//#endif
//		float currenty = 10;
//		float labelHeight = labelStyle.CalcHeight(new GUIContent("IBeacons"), Screen.width-20);
//		GUI.Label(new Rect(currenty,10,Screen.width-20,labelHeight),"IBeacons");
//		
//		currenty += labelHeight;
//		scrolldistance = GUI.BeginScrollView(new Rect(10,currenty,Screen.width -20, Screen.height - currenty - 10),scrolldistance,new Rect(0,0,Screen.width - 20,mybeacons.Count*100));
//		GUILayout.BeginVertical("box",GUILayout.Width(Screen.width-20),GUILayout.Height(50));
//		foreach (Beacon b in mybeacons) {
//			GUILayout.Label("UUID: "+b.UUID);
//			GUILayout.Label("Major: "+b.major);
//			GUILayout.Label("Minor: "+b.minor);
//			GUILayout.Label("Range: "+b.range.ToString());
//		}
//		GUILayout.EndVertical();
//		GUI.EndScrollView();
//	}
}
