Attribute VB_Name = "Declarations"
Option Explicit

'���H��1��
'�K���
Public Const SIZE As Long = 103
Public RangeMaze As Range

Public START As Range
Public GOAL As Range

'�F�萔
Public Const BUILT As Long = 0
Public Const BUILDING As Long = 255

Public Const SEARCHING As Long = 16776960
Public Const SEARCHED As Long = 12632256

Public Const ROUTE As Long = 16711680

'���p�萔
Public Const NORTH As Long = 0
Public Const EAST As Long = 1
Public Const SOUTH As Long = 2
Public Const WEST As Long = 3

'�i�s���(���F�̕���)���Ǘ�
Public TempSearch() As Range

'�H���Ă�����
Public TempRoute As Range
