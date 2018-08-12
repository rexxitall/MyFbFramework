﻿#Include Once "Component.bi"
#Include Once "IntegerList.bi"

Using My.Sys.ComponentModel

Dim Shared TimersList As IntegerList

Namespace My.Sys.Forms
    
    Type TimerComponent Extends Component
        Private:
            FEnabled As Boolean
            Declare Static Sub TimerProc(hwnd As HWND, uMsg As Uint, idEvent As Integer, dwTime As DWord)
        Public:
            Handle        As Integer
            Interval      As Integer
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnTimer As Sub(ByRef Sender As TimerComponent)
    End Type

    Sub TimerComponent.TimerProc(hwnd As HWND, uMsg As Uint, idEvent As Integer, dwTime As DWord)
        With TimersList
            If .Contains(idEvent) Then
                Var tmr = *Cast(TimerComponent Ptr, .Object(.IndexOf(idEvent)))
                If tmr.OnTimer Then tmr.OnTimer(tmr)
            End If
        End With
    End Sub
         

    Property TimerComponent.Enabled As Boolean
        Return FEnabled
    End Property
    
    Property TimerComponent.Enabled(Value As Boolean)
        FEnabled = Value
        If FEnabled Then
            Handle = SetTimer(Null, 0, Interval, @TimerProc)
            TimersList.Add Handle, @This
        Else
            If Handle Then KillTimer Null, Handle
            TimersList.Remove TimersList.IndexOf(Handle)
        End If
    End Property
    
    Operator TimerComponent.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TimerComponent
        Interval = 10
        Enabled = True
    End Constructor

    Destructor TimerComponent
        Enabled = False
    End Destructor
End namespace
