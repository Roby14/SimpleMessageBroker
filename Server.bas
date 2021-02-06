B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private serv As ServerSocket
	Private ClientMap As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	ClientMap.Initialize
	serv.Initialize(Vars.server_port,"serv")
	serv.Listen
End Sub

Private Sub serv_NewConnection (Successful As Boolean, NewSocket As Socket)
	If Successful Then
		If ClientMap.ContainsKey(NewSocket.RemoteAddress) Then
			Dim tmp As Client = ClientMap.Get(NewSocket.RemoteAddress)
			tmp.CloseClient
		End If

		Dim CL As Client
		CL.Initialize(NewSocket)
		ClientMap.Put(NewSocket.RemoteAddress,CL)
	End If
	serv.Listen
End Sub