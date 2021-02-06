B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private RoomMap As Map
	Private RouteClientRoomMap As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	RoomMap.Initialize
	RouteClientRoomMap.Initialize
End Sub

Public Sub getRoomList As List
	Return RoomMap.Keys
End Sub

Public Sub CreateRoom (roomname As String) As Boolean
	If RoomMap.ContainsKey(roomname) Then Return False
	
	Dim NewRoom As Room
	NewRoom.Initialize(roomname)
	
	RoomMap.Put(roomname,NewRoom)
	Return True
End Sub

Public Sub JoinRoom (cl As Client, roomname As String) As Boolean
	If RoomMap.ContainsKey(roomname) = False Then Return False
	
	Dim TmpRoom As Room = RoomMap.Get(roomname)
	TmpRoom.ClientJoin(cl)
	
	RouteClientRoomMap.Put(cl.ClientRemoteAddress,TmpRoom)
	Return True
End Sub

Public Sub SentMessage (SenderRemoteAddress As String, msg As String) As Boolean
	If RouteClientRoomMap.ContainsKey(SenderRemoteAddress) = False Then Return False
	
	Dim TmpRoom As Room = RouteClientRoomMap.Get(SenderRemoteAddress)
	Return TmpRoom.BroadcastMessage(SenderRemoteAddress,msg)
End Sub