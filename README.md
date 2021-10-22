Getting Started
If you plan on using this to look at messages in chat, you'll need the channel ID. In the "Get ID" folder there's a scene that shows you how to do that. In the "Basic HTTP Requests" scene, on Test, you want to enter the username who's ID you want. When you run the scene, press the button on screen, and in the debug log below it will display the ID.

It will look something like this
here is request
{data:{channel:{id:3052}}}
3052 being said ID in this scenario. 

In WebSocket.tscn, in the inspector you will put in your client ID, and the channel ID you got from the Get ID folder.

Now when you run any scene, when something is entered in chat, it should show up in game, and in the debug log.

Once this works, you can open up "viewer_as_npc_example" scene and you can then use two commands in chat
!npc create
!npc color [color_here]
example: !npc color cyan
npc create puts the viewer into the game, with their username above their NPC.
npc color can take any of the six arguments- red, lime, cyan, blue, purple, pink
