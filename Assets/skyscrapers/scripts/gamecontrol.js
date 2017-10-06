#pragma strict
var text : Transform;
var player : Transform;
var startpos : Vector3;
private var createdplayer : boolean = false;
private var playerdead : boolean = false;
function Start () 
{
 	text.gameObject.SetActive(true);

}

function Update () 
{
	if (!createdplayer || playerdead)
	{
		text.gameObject.SetActive(true);
		if(Input.anyKeyDown)
		{
			onstart();
		}
	}
	
	
	
	
	
	

}
function GameOver()
{
	print("gameover");
	playerdead = true;
}

function onstart()
{
	yield WaitForSeconds(0.8);
	if (!createdplayer || playerdead)
	{
		Instantiate(player, startpos, Quaternion.identity);
		text.gameObject.SetActive(false);
		createdplayer = true;
		playerdead = false;
	}
}