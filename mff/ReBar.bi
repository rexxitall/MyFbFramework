﻿'################################################################################
'#  ReBar.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QReBar(__Ptr__) *Cast(ReBar Ptr, __Ptr__)
    
    Type ReBar Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub ReBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QReBar(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub ReBar.WndProc(ByRef Message As Message)
    End Sub

    Sub ReBar.ProcessMessage(ByRef Message As Message)
    End Sub

    Operator ReBar.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor ReBar
        With This
            .RegisterClass "ReBar","ReBarWindow32"
            WLet FClassName, "ReBar"
            WLet FClassAncestor, "ReBarWindow32"
            .Style        = WS_CHILD
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor ReBar
        UnregisterClass "ReBar",GetModuleHandle(NULL)
    End Destructor
End Namespace
