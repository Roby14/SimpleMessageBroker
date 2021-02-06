B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private ClientMap As Map
	Private Details As RoomStruct
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(name As String)
	ClientMap.Initialize
	Details.Initialize
	
	Details.RoomName = name
End Sub

Public Sub getRoomName As String
	Return Details.RoomName
End Sub

Public Sub ClientJoin(CL As Client)
	If CL.ClientRemoteAddress = Null Then Return
	ClientMap.Put(CL.ClientRemoteAddress,CL)
End Sub

Public Sub BroadcastMessage(SenderRemoteAddress As String, msg As String) As Boolean
	If ClientMap.ContainsKey(SenderRemoteAddress) = False Then Return False
	Dim respond As Boolean = True
	For Each RemoteAddress As String In ClientMap.Keys
		If RemoteAddress = SenderRemoteAddress Then Continue
		Dim ReceiverClient As Client = ClientMap.Get(RemoteAddress)
		respond = respond Or ReceiverClient.BroadcastMessage(msg)
	Next
	return respond
End Sub