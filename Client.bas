B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private sock As Socket
	Private async As AsyncStreams
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(tempsock As Socket)
	If tempsock.IsInitialized Then 
		sock = tempsock
		async.Initialize(sock.InputStream,sock.OutputStream,"async")
	End If
End Sub

Private Sub async_Error
	CloseClient
End Sub

Private Sub async_Terminated
	CloseClient
End Sub

Public Sub CloseClient
	If async.IsInitialized Then async.Close
	If sock.IsInitialized Then sock.Close
End Sub

Public Sub getClientRemoteAddress As String
	If sock.IsInitialized And sock.Connected Then 
		Return sock.RemoteAddress
	Else
		Return Null
	End If
End Sub

Private Sub async_NewData (Buffer() As Byte)
	Dim buffstr As String = BytesToString(Buffer,0,Buffer.Length,"UTF-8")
	If buffstr.Contains("/roomlist") Then
		Dim roomlist As StringBuilder
		roomlist.Initialize
		For Each str As String In Main.RoomBridge.Roomlist
			roomlist.Append(str).Append(" ")
		Next
		BroadcastMessage(roomlist.ToString.SubString2(0,roomlist.ToString.Length-1))
	Else If buffstr.Contains("/createroom") Then
		Dim Split() As String = Regex.Split(" ",buffstr)
		Main.RoomBridge.CreateRoom(Split(1))
	Else if buffstr.Contains("/join") Then
		Dim Split() As String = Regex.Split(" ",buffstr)
		Main.RoomBridge.JoinRoom(Me,Split(1))
	Else If buffstr.Contains("/message") Then
		Dim message As String = buffstr.SubString(9)
		Main.RoomBridge.SentMessage(getClientRemoteAddress,message)
	End If
End Sub

Public Sub BroadcastMessage(msg As String) As Boolean
	If async.IsInitialized = False Then Return False
	Return async.Write(msg.GetBytes("UTF8"))
End Sub