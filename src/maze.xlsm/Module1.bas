Attribute VB_Name = "Module1"
Option Explicit

'���H��1��
'�K���
Const SIZE As Long = 103

Public Start As Range
Public Goal As Range

Public Get2Start As Boolean
Public Get2Goal As Boolean


Public RangeMaze As Range

'�i�s���(���F�̕���)���Ǘ�
Public listCandidate() As Range

'�F�萔
Const ColorSTART As Long = 65280
Const ColorGOAL As Long = 255

Const BUILT As Long = 0
Const BUILDING As Long = 255

Const SEARCHING As Long = 16776960
Const SEARCHED As Long = 12632256

Const ROUTE As Long = 16711680

'���p�萔
Const NORTH As Long = 1
Const EAST As Long = 2
Const SOUTH As Long = 3
Const WEST As Long = 4

Sub main()
    
    ReDim listCandidate(0 To 0)
    
    Get2Start = False
    Get2Goal = False
    
    DefaultHeightWidth
    
    Dim Target As Range

    Set RangeMaze = Range(Cells(1, 1), Cells(SIZE, SIZE))
    
    Application.StatusBar = "���H�𐶐����Ă��܂�..."
    
    'MakeMaze
    MakeMaze
    
    Application.StatusBar = "�X�^�[�g/�S�[���n�_��ݒ肵�Ă��܂�..."

    Set Start = Cells(2, 2)
    Start.Interior.Color = ColorSTART
    
    Set Goal = Cells(SIZE - 1, SIZE - 1)
    Goal.Interior.Color = ColorGOAL
    
    Application.StatusBar = "�ŒZ�o�H�T�����s���܂�..."
        
    SetNext Start
    Do While Get2Start = False
        SetNext GetNext
        DoEvents
    Loop
        
    Set Target = Back2Start(Goal)
    Do While Get2Goal = False
        Set Target = Back2Start(Target)
        DoEvents
    Loop
    
    Application.StatusBar = "�ŒZ�o�H��T�����܂����B"
    
End Sub

Function MakeMaze()

    '�ǌ��(x,y�Ƃ�����g�ł͂Ȃ�)���Ǘ�
    Dim listMakeMaze() As Range
    ReDim listMakeMaze(0 To 0)
    '���ݒ��̕�(��)���Ǘ�
    Dim listBuilding() As Range
    ReDim listBuilding(0 To 0)
    
    '���H�̏�����
    RangeMaze.Rows.RowHeight = 5 * 0.75
    RangeMaze.Columns.ColumnWidth = 5 * 0.07
    
    Cells(SIZE + 1, SIZE + 1).Select
    
    '�O����ǂ�
    RangeMaze.Interior.Color = BUILT
    Range(RangeMaze.Cells(2, 2), RangeMaze.Cells(RangeMaze.Rows.Count - 1, RangeMaze.Columns.Count - 1)).ClearFormats
    
    Dim i As Long
    Dim j As Long
    '�ǌ����W�̃��X�g���쐬
    For i = 3 To SIZE - 2 Step 2
        For j = 3 To SIZE - 2 Step 2
            
            '�ǌ��(x,y�Ƃ�����g�ł͂Ȃ�)��ǉ�
            ReDim Preserve listMakeMaze(0 To UBound(listMakeMaze) + 1)
            Set listMakeMaze(UBound(listMakeMaze)) = Cells(i, j)
            
        Next j
    Next i
        
    Dim prev As Long
    prev = UBound(listMakeMaze) - 1
    Application.StatusBar = "���H�𐶐����Ă��܂�... - 0%"
        
    Dim Selected As Range
    
    Dim temp As Long
    Dim Direction As Long '���������� '1�k�E2���E3��E4��
    Dim CantEnter(1 To 4) As Boolean '�i�߂Ȃ��ꍇ��true
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    Dim Target As Range '�i�s��
    
    Do While True
        
        i = 0
        
        '�ǌ�₩�烉���_���Ɏ��o��
        'Int((�ő�l - �ŏ��l + 1) * Rnd + �ŏ��l)
        Randomize
        temp = Int((UBound(listMakeMaze) - (LBound(listMakeMaze) + 1) + 1) * Rnd + (LBound(listMakeMaze) + 1))
        
        Set Selected = listMakeMaze(temp)
        
        vTemp = Selected.Row
        hTemp = Selected.Column
        
        '���ǐL�΂�����
        '�w����W��ǂ�
        Selected.Interior.Color = BUILDING
        ReDim Preserve listBuilding(0 To UBound(listBuilding) + 1)
        Set listBuilding(UBound(listBuilding)) = Selected
        
        '�i�s�����������_���Ɍ���
        BoolReset CantEnter
        
        Do While True
        
            Randomize
            Direction = Int(4 * Rnd + 1)
            
            '�i�s��̏󋵂��擾
            Select Case Direction
                Case NORTH
                    Set Target = Cells(vTemp - 2, hTemp)
                Case EAST
                    Set Target = Cells(vTemp, hTemp + 2)
                Case SOUTH
                    Set Target = Cells(vTemp + 2, hTemp)
                Case WEST
                    Set Target = Cells(vTemp, hTemp - 2)
            End Select
            
            If Target.Interior.Color = BUILT Then '�i�s�悪�����̕ǂ̏ꍇ
                Range(Cells(vTemp, hTemp), Target).Interior.Color = BUILDING
                
                ReDim Preserve listBuilding(0 To UBound(listBuilding) + 1)
                Set listBuilding(UBound(listBuilding)) = Range(Cells(vTemp, hTemp), Target)
                
                Exit Do
                
            ElseIf Target.Interior.Color = BUILDING Then '���ݒ��̕ǂ̏ꍇ
                Select Case Direction
                    Case NORTH
                        CantEnter(NORTH) = True
                    Case EAST
                        CantEnter(EAST) = True
                    Case SOUTH
                        CantEnter(SOUTH) = True
                    Case WEST
                        CantEnter(WEST) = True
                End Select
            
            Else '�ʘH�̏ꍇ
                Range(Cells(vTemp, hTemp), Target).Interior.Color = BUILDING
                
                ReDim Preserve listBuilding(0 To UBound(listBuilding) + 1)
                Set listBuilding(UBound(listBuilding)) = Range(Cells(vTemp, hTemp), Target)
                
                '�g�p���ꂽ�ǌ��̓��X�g����폜
                If UBound(listMakeMaze) <> 1 Then
                    listMakeMaze = RangeArrDelete(listMakeMaze, Target)
                    Application.StatusBar = "���H�𐶐����Ă��܂�... - " & Round((prev - UBound(listMakeMaze)) / prev, 2) * 100 & "%"
                Else
                    listMakeMaze = RangeArrDelete(listMakeMaze, Target)
                    Application.StatusBar = "���H�𐶐����Ă��܂�... - 100%"
                    Exit Function
                End If
                
                vTemp = Target.Row
                hTemp = Target.Column
                
                BoolReset CantEnter
                
            End If
            
            If CantEnter(NORTH) = True And CantEnter(EAST) = True And CantEnter(SOUTH) = True And CantEnter(WEST) = True Then '�ǂ̕����ɂ��i�߂Ȃ��Ȃ�����V���Ȍ������
                Exit Do
            End If
            
            DoEvents
        Loop
        
        
        '���ݒ��̃��X�g��S�Č��ݍς݂�
        For i = LBound(listBuilding) + 1 To UBound(listBuilding)
            listBuilding(i).Interior.Color = BUILT
        Next i
        ReDim listBuilding(0 To 0)
        
        '�g�p���ꂽ�ǌ��̓��X�g����폜
        If UBound(listMakeMaze) <> 1 Then
            listMakeMaze = RangeArrDelete(listMakeMaze, Selected)
            Application.StatusBar = "���H�𐶐����Ă��܂�... - " & Round((prev - UBound(listMakeMaze)) / prev, 2) * 100 & "%"
        Else
            listMakeMaze = RangeArrDelete(listMakeMaze, Selected)
            Application.StatusBar = "���H�𐶐����Ă��܂�... - 100%"
            Exit Do
        End If
        
        DoEvents
    Loop
    
End Function

Function DefaultHeightWidth()
    ActiveSheet.Cells.Clear
    ActiveSheet.Rows.RowHeight = 18.75
    ActiveSheet.Columns.ColumnWidth = 8.38
    ActiveSheet.Range(Cells(1, 1), Cells(Rows.Count, Columns.Count)).ClearFormats
    ActiveSheet.Cells(1, 1).Select
End Function

Function BoolReset(ByRef arr() As Boolean)
    
    Dim i As Long
    For i = LBound(arr) To UBound(arr)
        arr(i) = False
    Next i
    
End Function

'���0���c���Ă����K�v������
'�Y������1����n�܂�
'listCandidate����Range���폜
Function RangeArrDelete(ByRef arr() As Range, ByVal Target As Range) As Range()
    
    Dim i As Long
    Dim copy() As Range
    Dim flag As Boolean
    flag = False
    
    For i = LBound(arr) + 1 To UBound(arr)
        If arr(i).Row = Target.Row And arr(i).Column = Target.Column Then
            flag = True
        Else
            If flag = False Then
                ReDim Preserve copy(LBound(arr) To i)
                Set copy(i) = arr(i)
            Else
                ReDim Preserve copy(LBound(arr) To i - 1)
                Set copy(i - 1) = arr(i)
            End If
        End If
    Next i
    
    RangeArrDelete = copy
    
End Function

Function SetNext(ByVal Target As Range) As Range
    
    
    '�I�𒆂̐F : 0,255,255
    '�T���ς݂̐F : 192,192,192
    
    '���E�㉺�̐i�s�\�Z�����}�[�L���O
    
    Dim Directions(0 To 3) As Range
    Set Directions(0) = Target.Cells(0, 1)
    Set Directions(1) = Target.Cells(1, 2)
    Set Directions(2) = Target.Cells(2, 1)
    Set Directions(3) = Target.Cells(1, 0)
    
    Dim i As Long
    
    For i = 0 To 3
        If Directions(i).Interior.Color = ColorGOAL Then '�S�[���ɂ��ǂ�����ꍇ
            AllCellsChecked
            Get2Start = True
            Exit Function
        End If
        If IsAvailable(Directions(i)) Then '�ǂ��T���ς݂ł͂Ȃ��ꍇ
            
            Directions(i).Interior.Color = SEARCHING
            Directions(i).Value = Target.Value + 1
            
            '�Y������1����n�܂�A0�ɂ͋󔒂̃f�[�^
            '�v�f����0�ɂȂ�Ƃ܂�������
            
            ReDim Preserve listCandidate(0 To UBound(listCandidate) + 1)
            Set listCandidate(UBound(listCandidate)) = Directions(i)
            
        End If
    Next i
    
    If Target.Interior.Color <> Start.Interior.Color Then
        Target.Interior.Color = SEARCHED
        listCandidate = RangeArrDelete(listCandidate, Target)
    End If
    
End Function

Function GetNext() As Range
    Dim i As Long
    Dim minimum As Long
    minimum = 2147483647
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    For i = LBound(listCandidate) + 1 To UBound(listCandidate)
        'If minimum >= listcandidate(i).Value + CLng(Sqr((Abs(listcandidate(i).Row - Goal.Row)) ^ 2 + (Abs(listcandidate(i).Row - Goal.Row)) ^ 2)) Then '�X�^�[�g����̋���+�S�[���܂ł̋���(��������)
        If minimum >= listCandidate(i).Value + Abs(listCandidate(i).Row - Goal.Row) + Abs(listCandidate(i).Row - Goal.Row) Then '�X�^�[�g����̋���+�S�[���܂ł̋���(�ӂ̍��v)
            minimum = listCandidate(i).Value + CLng(Sqr((Abs(listCandidate(i).Row - Goal.Row)) ^ 2 + (Abs(listCandidate(i).Row - Goal.Row)) ^ 2))
            
            Set GetNext = listCandidate(i)
            
        End If
    Next
    
End Function

Function IsAvailable(ByVal Target As Range) As Boolean
    
    If Target.Interior.Color <> BUILT And Target.Interior.Color <> SEARCHING And Target.Interior.Color <> SEARCHED And Target.Interior.Color <> ColorSTART Then
        IsAvailable = True
    End If
    
End Function

'�ċA�ŃX�^�[�g�܂ŋA��
Function Back2Start(ByVal Target As Range) As Range
    
    Dim Directions(0 To 3) As Range
    Set Directions(0) = Target.Cells(0, 1)
    Set Directions(1) = Target.Cells(1, 2)
    Set Directions(2) = Target.Cells(2, 1)
    Set Directions(3) = Target.Cells(1, 0)
    
    Dim i As Long
    
    For i = 0 To 3 '4�����ɃX�^�[�g������ΏI��
        If Directions(i).Interior.Color = ColorSTART Then
            Get2Goal = True
            Exit Function
        End If
    Next i
    
    Dim val(0 To 3) As Long '�e�Z���̒l(�X�^�[�g�܂ł̋���)���ł��Z�����̂�I��
    For i = 0 To 3
        val(i) = CastValue(Directions(i).Value)
    Next i
    
    Dim s As Long
    s = Smallest(val)
    Directions(s).Interior.Color = RGB(0, 0, 255)
    
    Set Back2Start = Directions(s)
    
End Function

'�I�𒆂̐��F�Z����S�ĊD�F�ɂ���
Function AllCellsChecked()
    Dim cell As Range
    
    For Each cell In RangeMaze
        If cell.Interior.Color = SEARCHING Then
            cell.Interior.Color = SEARCHED
        End If
    Next
    
End Function

'�z��̂����ŏ��̒l�������Ă���Y������Ԃ�
Function Smallest(ByRef arr() As Long) As Long
    Dim i As Long
    
    Dim sNum As Long
    sNum = 2147483647
    
    For i = LBound(arr) To UBound(arr)
        If arr(i) < sNum Then
            Smallest = i
            sNum = arr(i)
        End If
    Next i
End Function

'�󔒕�����Long�^�̍ő�l�ɂ��ĕԂ�
Function CastValue(ByVal str As String) As Long
    If str = "" Or str = vbNullString Then
        CastValue = 2147483647
    Else
        CastValue = CLng(str)
    End If
End Function
