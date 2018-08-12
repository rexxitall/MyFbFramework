﻿'###############################################################################
'#  RichTextBox.bi                                                                #
'#  This file is part of MyFBFramework                        				   #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "TextBox.bi"

namespace My.Sys.Forms
	#DEFINE QRichTextBox(__Ptr__) *Cast(RichTextBox Ptr,__Ptr__)

	Dim Shared textbuffer As WString Ptr, bufferpos As Integer

	Type RichTextBox Extends TextBox
		Private:
			Declare Static Sub WndProc(BYREF message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			FFindText As WString Ptr
			FTextRange As WString Ptr
		Protected:
			hRichTextBox As HINSTANCE
			FEditStyle As Boolean
			FZoom As Integer
			Declare Sub ProcessMessage(BYREF message As Message)
		Public:
			Declare Function CanRedo As Boolean
			Declare Function GetCharIndexFromPos(p As Point) As Integer
			Declare Function GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As Wstring
			Declare Function Find(ByRef Value As WString) As Boolean
			Declare Function FindNext(ByRef Value As WString = "") As Boolean
			Declare Function FindPrev(ByRef Value As WString = "") As Boolean
			Declare Function BottomLine As Integer
			Declare Property SelText ByRef As WString
			Declare Property SelText(ByRef Value As WString)
			Declare Property TextRTF ByRef As WString
			Declare Property TextRTF(ByRef Value As WString)
			Declare Property SelColor As Integer
			Declare Property SelColor(Value As Integer)
			Declare Property EditStyle As Boolean
			Declare Property EditStyle(Value As Boolean)
			Declare Property Zoom As Integer
			Declare Property Zoom(Value As Integer)
			Declare Sub LoadFromFile(ByRef File As WString, bRTF As Boolean)
			Declare Sub SaveToFile(ByRef File As WString, bRTF As Boolean)
			Declare Sub Undo
			Declare Sub Redo
			Declare Operator Cast As My.Sys.Forms.Control Ptr
			Declare Constructor
			Declare Destructor
			OnSelChange As Sub(BYREF Sender As RichTextBox)
	End Type

	Function RichTextBox.GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As Wstring
		Dim cpMax2 As Integer = cpMax
		Dim txtrange As TEXTRANGE
		If cpMax2 = -1 Then cpMax2 = This.GetTextLength
		FTextRange = Cast(WString Ptr, Reallocate(FTextRange, (cpMax - cpMin + 2) * SizeOf(WString)))
		txtrange.chrg.cpMin = cpMin
		txtrange.chrg.cpMax = cpMax
		txtrange.lpstrText = FTextRange
		SendMessage(FHandle, EM_GETTEXTRANGE, 0, CInt(@txtrange))
		Return *FTextRange
	End FUnction
	
	Property RichTextBox.SelColor As Integer
		Dim Cf As CHARFORMAT
		cf.cbSize = Sizeof(cf)
		cf.dwMask = CFM_COLOR
		Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LParam, @cf))
		Return cf.crTextColor
	End Property
	
	Property RichTextBox.SelColor(Value As Integer)
		Dim Cf As CHARFORMAT
		cf.cbSize = Sizeof(cf)
		cf.dwMask = CFM_COLOR
		cf.crTextColor = Value
		Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LParam, @cf))
	End Property

	Function RichTextBox.GetCharIndexFromPos(p As Point) As Integer
		Return Perform(EM_CHARFROMPOS, 0, Cint(@p))
	End Function

	Property RichTextBox.Zoom As Integer
		Dim As Integer wp, lp
		Var Result = 100
  		Perform(EM_GETZOOM, CInt(@wp), Cint(@lp))
  		If (lp > 0) Then Result = MulDiv(100, wp, lp)
		Return Result
	End Property
 	
	Property RichTextBox.Zoom(Value As Integer)
		If Value = 0 Then
      		Perform(EM_SETZOOM, 0, 0)
    		Else
      		Perform(EM_SETZOOM, Value, 100)
		End If
	End Property
 
	Function RichTextBox.BottomLine As Integer
		Dim r As Rect, i As Integer
		Perform(EM_GETRECT, 0, CInt(@r))
		r.Left = r.Left + 1
		r.Top  = r.Bottom - 2
		i = Perform(EM_CHARFROMPOS, 0, Cint(@r))
		Return Perform(EM_EXLINEFROMCHAR, 0, i)
	End Function
 
	Function RichTextBox.CanRedo As Boolean
		If FHandle Then 
		   Return (Perform(EM_CANREDO, 0, 0) <> 0)
	   Else
		   Return 0
	   End If
	End Function

	Sub RichTextBox.Undo
		If FHandle Then Perform(EM_UNDO, 0, 0)
	End Sub

	Sub RichTextBox.Redo
		If FHandle Then Perform(EM_REDO, 0, 0)
	End Sub
	
	Function RichTextBox.Find(ByRef Value As Wstring) As Boolean
		If FHandle = 0 Then Return False
		Dim ft As FINDTEXTEX, Result As Integer
		FFindText = ReAllocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
		*FFindText = Value
		ft.lpstrText = FFindText
		ft.chrg.cpMin = 0
		ft.chrg.cpMax = -1
		Result = Perform(EM_FINDTEXTEX, FR_DOWN, Cast(Lparam, @ft))
		If Result = -1 Then 
			Return False
		Else
			Perform(EM_EXSETSEL, 0, Cast(LParam, @ft.chrgText))
			Return True
		End If
	End Function
	
	Function RichTextBox.FindNext(ByRef Value As Wstring = "") As Boolean
		If FHandle = 0 Then Return False
		Dim ft As FINDTEXTEX, Result As Integer
		If Value <> "" Then
			FFindText = ReAllocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
			*FFindText = Value
		End if
		If FFindText = 0 Then Exit Function
		Perform(EM_EXGETSEL, 0, Cast(LPARAM, @ft.chrg))
		ft.lpstrText = FFindText
		If ft.chrg.cpMin <> ft.chrg.cpMax Then
			ft.chrg.cpMin = ft.chrg.cpMax
		Endif
		ft.chrg.cpMax = -1
		Result = Perform(EM_FINDTEXTEX, FR_DOWN, Cast(Lparam, @ft))
		If Result = -1 Then 
			Return False
		Else
			Perform(EM_EXSETSEL, 0, Cast(LParam, @ft.chrgText))
			Return True
		End If
	End Function
	
	Function RichTextBox.FindPrev(ByRef Value As Wstring = "") As Boolean
		If FHandle = 0 Then Return False
		Dim ft As FINDTEXTEX, Result As Integer
		If Value <> "" Then
			FFindText = ReAllocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
			*FFindText = Value
		End if
		If FFindText = 0 Then Exit Function
		Perform(EM_EXGETSEL, 0, Cast(LPARAM, @ft.chrg))
		ft.lpstrText = FFindText
		ft.chrg.cpMax = 0
		Result = Perform(EM_FINDTEXTEX, 0, Cast(Lparam, @ft))
		If Result = -1 Then 
			Return False
		Else
			Perform(EM_EXSETSEL, 0, Cast(LParam, @ft.chrgText))
			Return True
		End If
	End Function
	
	Sub RichTextBox.WndProc(BYREF message As Message)
	End Sub

	Sub RichTextBox.ProcessMessage(BYREF message As Message)
		'?message.msg & ": " & GetMessageName(message.msg)
		Base.ProcessMessage(message)
		Select Case message.Msg
		Case CM_COMMAND
			Select Case Message.wParamHi
			Case EN_SELCHANGE
				If OnSelChange Then OnSelChange(This)
			End Select
			message.result = 0
		Case WM_PASTE
			Dim Action AS Integer = 1
			If OnPaste Then OnPaste(This, Action)
			Select Case Action
			Case 0: message.result = -1
			Case 1: message.result = 0
			Case 2: message.result = -2
				Dim As REPASTESPECIAL reps
				reps.dwAspect = 0
				reps.dwParam = 0
				message.msg = EM_PASTESPECIAL
				message.wParam = CF_TEXT
				message.lParam = Cast(LPARAM, @reps)
			End Select
		End Select
	End Sub

	Property RichTextBox.EditStyle As Boolean
		Return FEditStyle
	End Property
	
	Property RichTextBox.EditStyle(Value As boolean)
		FEditStyle = Value
		If FHandle Then
			If FEditStyle Then Perform(EM_SETEDITSTYLE, 1, 1)
		End If
	End Property
	
	Property RichTextBox.SelText ByRef As WString
		Dim As Integer LStart, LEnd
		If FHandle Then
			Dim charArr As CHARRANGE 
			SendMessage(FHandle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
			If LEnd - LStart <= 0 Then
				FSelText = Reallocate(FSelText, SizeOf(WString))
				*FSelText = ""
			Else
				FSelText = Reallocate(FSelText, (LEnd - LStart + 1 + 1) * SizeOf(WString))
				*FSelText = String(LEnd - LStart + 1, 0)
				SendMessage(FHandle, EM_GETSELTEXT, 0, Cast(LParam, FSelText))
			End If
		End If
		Return *FSelText
	End Property
	
	Property RichTextBox.SelText(ByRef Value As WString)
		FSelText = Reallocate(FSelText, (Len(Value) + 1) * SizeOf(WString))
		*FSelText = Value
		Dim stSetText As SETTEXTEX
		stSetText.Flags = ST_KEEPUNDO
		stSetText.codepage = 1200
		SendMessage(FHandle, EM_REPLACESEL, Cast(wParam, @stSetText), Cast(LParam, FSelText))
	End Property

	Function StreamInProc(hFile As Handle, pBuffer As PVOID, NumBytes As Integer, pBytesRead As Integer Ptr) As BOOl
    		Dim As Integer length
		If hFile = 10000 Then
			WReallocate textbuffer, bufferpos + NumBytes
			*textbuffer = *textbuffer + *Cast(WString Ptr, pBuffer)
			bufferpos = Len(*textbuffer)
			length = Len(Cast(WString Ptr, pBuffer)) * SizeOf(WString)
		Else
	    		ReadFile(hFile,pBuffer,NumBytes,Cast(LPDWORD,@length),0)
		End If
    		*pBytesRead = length
    		If length = 0 Then
        		Return 1
    		Endif
	End Function

	Function StreamOutProc (hFile As Handle, pBuffer As PVOID, NumBytes As Integer, pBytesWritten As Integer Ptr) As bool
    		Dim As Integer length
		If hFile = 10000 Then
			'm utf16BeByte2wchars(*Cast(Byte Ptr, pBuffer))
			*Cast(WString Ptr, pBuffer) = Mid(*textbuffer, bufferpos + 1, NumBytes / SizeOf(WString))
			bufferpos = bufferpos + Len(*Cast(WString Ptr, pBuffer))
			length = Len(*Cast(WString Ptr, pBuffer)) * SizeOf(WString)
		Else
	    		WriteFile(hFile,pBuffer,NumBytes,Cast(LPDWORD,@length),0)
		End If
    		*pBytesWritten = length
    		If length = 0 Then
        		Return 1
    		End if
	End Function

	Property RichTextBox.TextRTF ByRef As WString
		If FHandle Then
			Dim editstream As EDITSTREAM
			bufferPos = 0
                  editstream.dwCookie = Cast(DWORD, 10000)
			editstream.pfnCallback = Cast(EDITSTREAMCALLBACK, @StreamOutProc)
                  SendMessage(FHandle, EM_STREAMOUT, SF_RTF, Cast(LPARAM, @editstream))
			Return *textbuffer
		End If
	End Property
	
	Property RichTextBox.TextRTF(ByRef Value As WString)
		If FHandle Then
			Dim editstream As EDITSTREAM
			WReallocate textbuffer, Len(Value)
			*textbuffer = Value
			bufferPos = 0
                  editstream.dwCookie = Cast(DWORD, 10000)
      	      editstream.pfnCallback = Cast(EDITSTREAMCALLBACK, @StreamInProc)
            	SendMessage(FHandle, EM_STREAMIN, SF_RTF, Cast(LPARAM, @editstream))
		End If
	End Property

	Sub RichTextBox.LoadFromFile(ByRef Value As WString, bRTF As Boolean)
		If FHandle Then
			Dim hFile As Handle
			hFile = CreateFile(@Value, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
                  If hFile <> INVALID_HANDLE_VALUE Then
				Dim editstream As EDITSTREAM
                  	editstream.dwCookie = Cast(DWORD_Ptr, hFile)
                  	editstream.pfnCallback = Cast(EDITSTREAMCALLBACK, @StreamInProc)
                  	SendMessage(FHandle, EM_STREAMIN, IIF(bRTF, SF_RTF, SF_TEXT), Cast(LPARAM, @editstream))
                  	SendMessage(FHandle, EM_SETMODIFY, FALSE, 0)
                  	CloseHandle(hFile)
			End If
             Endif
	End Sub
	
	Sub RichTextBox.SaveToFile(ByRef Value As WString, bRTF As Boolean)
		If Not bRTF Then
			Base.SaveToFile(Value)
		ElseIf FHandle Then
			Dim hFile As Handle			
			hFile = CreateFile(@Value, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)
	            If hFile <> INVALID_HANDLE_VALUE Then
				Dim editstream As EDITSTREAM
	            	editstream.dwCookie = Cast(DWORD_Ptr,hFile)
	                  editstream.pfnCallback= Cast(EDITSTREAMCALLBACK,@StreamOutProc)
	                  SendMessage(FHandle, EM_STREAMOUT, IIF(bRTF, SF_RTF, SF_TEXT), Cast(LPARAM, @editstream))
	                  SendMessage(FHandle, EM_SETMODIFY, FALSE, 0)
	                  CloseHandle(hFile)
			End If
		End If
	End Sub
	
	Sub RichTextBox.HandleIsAllocated(BYREF Sender As Control)
		If Sender.Child Then
			With QRichTextBox(Sender.Child)
				If .MaxLength <> 0 Then
					.MaxLength = .MaxLength
				End If
				If .EditStyle Then
					.EditStyle = .EditStyle
				End If
				.Perform(EM_SETEVENTMASK, 0, .Perform(EM_GETEVENTMASK, 0, 0) Or ENM_CHANGE Or ENM_SCROLL OR ENM_SELCHANGE Or ENM_CLIPFORMAT Or ENM_MOUSEEVENTS) 
			End With
		End If
	End Sub
	
	Operator RichTextBox.Cast As Control Ptr 
		Return Cast(Control Ptr, @This)
	End Operator

	Constructor RichTextBox
		hRichTextBox = LoadLibrary("RICHED20.DLL")
		FHideSelection    = False
		With This
			.RegisterClass "RichTextBox", "RichEdit20W"
			.ClassName = "RichTextBox"
			.ClassAncestor = "RichEdit20W"
			.OnHandleIsAllocated = @HandleIsAllocated
			.Child       = @This
			.ChildProc   = @WndProc
			.Width       = 121
			.Height      = 121
		End With
	End Constructor

	Destructor RichTextBox
		If FFindText Then Deallocate FFindText
		If FTextRange Then Deallocate FTextRange
		FreeLibrary(hRichTextBox)
	End Destructor
End Namespace
