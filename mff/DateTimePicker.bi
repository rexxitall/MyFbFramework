﻿'################################################################################
'#  DateTimePicker.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QDateTimePicker(__Ptr__) *Cast(DateTimePicker Ptr, __Ptr__)
    
    Type DateTimePicker Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub DateTimePicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QDateTimePicker(Sender.Child)
                Var SMD = Sender.Handle
                 Dim ST As SYSTEMTIME 
ST.wYear=2000 
ST.wmonth=1 
ST.wday=1 
ST.wHour=0 
ST.wMinute=1 
ST.wSecond=0 
Dim s As String 
s = "HH" & ":" & "mm" & ":" & "ss" 
'SendMessage(SMD, DTM_SETFORMATW,0, Cast(LPARAM,@s)) 
SendMessage(SMD,DTM_SETSYSTEMTIME,0,Cast(LPARAM,@ST))
            End With
        End If
    End Sub

    Sub DateTimePicker.WndProc(ByRef Message As Message)
    End Sub

    Sub DateTimePicker.ProcessMessage(ByRef Message As Message)
        Base.ProcessMessage(Message)
    End Sub

    Operator DateTimePicker.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor DateTimePicker
        Dim As Boolean Result
    
        'Dim As INITCOMMONCONTROLSEX ICC
    
        'ICC.dwSize = SizeOF(ICC)
    
        'ICC.dwICC  = ICC_DATE_CLASSES
    
        'Result = InitCommonControlsEx(@ICC)
        'If Not Result Then InitCommonControls
        Text = ""
        With This
            Base.RegisterClass WStr("DateTimePicker"), WStr("SysDateTimePick32")
            WLet FClassName, "DateTimePicker"
            WLet FClassAncestor, "SysDateTimePick32"
            .ExStyle      = 0 'WS_EX_LEFT OR WS_EX_LTRREADING OR WS_EX_RIGHTSCROLLBAR OR WS_EX_CLIENTEDGE
            .Style        = WS_CHILD Or DTS_SHORTDATEFORMAT 'Or DTS_RIGHTALIGN Or WS_VISIBLE Or WS_TABSTOP OR DTS_SHORTDATEFORMAT
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor DateTimePicker 
        UnregisterClass "DateTimePicker",GetModuleHandle(NULL)
    End Destructor
End Namespace
