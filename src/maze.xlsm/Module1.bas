Attribute VB_Name = "Module1"
Option Explicit

'true�ɂ���ƃX�^�[�g�ƃS�[������͂ł���
Public GlobalToolSwitch As Boolean
'�ݒ肵�I������true
Public SetStart As Boolean
Public SetGoal As Boolean

Public size As Long

Public Start As Range
Public Goal As Range

Public Get2Start As Boolean
Public Get2Goal As Boolean


Public RangeMaze As Range

'�i�s���(���F�̕���)���Ǘ�
Public listCandidate() As Range

Sub main()
    
    ReDim listCandidate(0 To 0)
    
'    On Error GoTo StackOverflow
    
    Dim flag As Boolean
    flag = False
    Get2Start = False
    Get2Goal = False
    
    DefaultHeightWidth
    
    GlobalToolSwitch = False
    SetStart = False
    SetGoal = False
    
    '�ǂ�1
    '�ʘH��0
    '���ݒ��̕ǂ�2
    '�v�f��5�ȏ�
    Dim maze() As Integer
    
    Dim target As Range
    
'    Dim temp As String
'    temp = InputBox("�T�C�Y��3�ȏ�̊�œ��͂��Ă��������B")
'
'    If temp <> "" Then
'        If IsNumeric(temp) = True Then
'            size = CLng(temp)
'        Else
'            Exit Sub
'        End If
'    End If
'
'    If size < 3 Then
'        size = 3
'    End If
'    If size Mod 2 = 0 Then
'        size = size + 1
'    End If
    
    '�����ŃT�C�Y�����肷��
    Do While True
        Randomize
        size = Int((201 - 181 + 1) * Rnd + 181) 'Int((51 - 3 + 1) * Rnd + 3)
        If size Mod 2 <> 0 Then
            Exit Do
        End If
    Loop

'    size = 501

    
'    Dim t As Double
'    t = Timer
    
    ReDim maze(0 To size + 1, 0 To size + 1)
    
    'MakeMaze
    MakeMaze maze
    
    '�`��
    DrawMaze maze
    
    Set RangeMaze = Range(Cells(1, 1), Cells(size + 2, size + 2))
    
    
    'MsgBox Round(Timer - t, 2) & " sec."
    
    'SetNext
'    MsgBox "�X�^�[�g�n�_��I�����Ă��������B"
'    GlobalToolSwitch = True
'    Do While GlobalToolSwitch = True
'        DoEvents
'    Loop
    
    '�����_���ɊJ�n�n�_�ƏI���n�_���w�肷��
    
    Randomize
    Set target = Cells(Int((size + 2 - 1 + 1) * Rnd + 1), Int((size + 2 - 1 + 1) * Rnd + 1))
    Do While target.Interior.Color = RGB(0, 0, 0)
        Randomize
        Set target = Cells(Int((size + 2 - 1 + 1) * Rnd + 1), Int((size + 2 - 1 + 1) * Rnd + 1))
    Loop
    
'    If target.Row Mod 2 <> 0 Then
'        Set target = Cells(target.Row + 1, target.Column)
'    End If
'    If target.Column Mod 2 <> 0 Then
'        Set target = Cells(target.Row, target.Column + 1)
'    End If
    
    Set Start = target
    Start.Interior.Color = RGB(0, 255, 0)
    
    Randomize
    Set target = Cells(Int((size + 2 - 1 + 1) * Rnd + 1), Int((size + 2 - 1 + 1) * Rnd + 1))
    Do While target.Interior.Color = RGB(0, 0, 0)
        Randomize
        Set target = Cells(Int((size + 2 - 1 + 1) * Rnd + 1), Int((size + 2 - 1 + 1) * Rnd + 1))
    Loop
    
'    If target.Row Mod 2 <> 0 Then
'        Set target = Cells(target.Row + 1, target.Column)
'    End If
'    If target.Column Mod 2 <> 0 Then
'        Set target = Cells(target.Row, target.Column + 1)
'    End If
    
    Set Goal = target
    Goal.Interior.Color = RGB(255, 0, 0)
    
    MsgBox "�ŒZ�o�H�T�����s���܂��B"
        
    SetNext Start
    Do While Get2Start = False
        SetNext GetNext
        DoEvents
    Loop
        
    Set target = Back2Start(Goal)
    Do While Get2Goal = False
        Set target = Back2Start(target)
    Loop
    
    MsgBox "�ŒZ�o�H��T�����܂����B"
    flag = True
    
StackOverflow:
    If flag <> True Then
        MsgBox "�X�^�b�N�̈悪�s�����Ă��܂��B"
    End If
    
End Sub

Function MakeMaze(ByRef maze() As Integer)
    
    Dim i As Long
    Dim j As Long
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    Dim vStart As Long
    Dim hStart As Long
    
    Dim Direction As Long
    
    '���ꂼ��k���쐼�ɑΉ�
    '�i�s�s�\�ɂȂ��True
    Dim bool(3) As Boolean
    '����
    '�l�ޒ��O��i�񂾕���
    Dim flag(3) As Boolean
    
    '���H��������
    '�O����ǂƂ��A����ȊO��ʘH�Ƃ���
    For i = LBound(maze, 1) To UBound(maze, 1)
        For j = LBound(maze, 2) To UBound(maze, 2)
            If i = LBound(maze, 1) Or j = LBound(maze, 2) Or i = UBound(maze, 1) Or j = UBound(maze, 2) Then
                maze(i, j) = 1
            Else
                maze(i, j) = 0
            End If
        Next j
    Next i
    
    'Int((�ő�l - �ŏ��l + 1) * Rnd + �ŏ��l)
    
    '�ǐL�΂������W
    Dim tempAvailable() As String
    ReDim tempAvailable(0 To (UBound(maze, 1) - 2) / 2 - 1, 0 To (UBound(maze, 2) - 2) / 2 - 1)
    For i = 0 To UBound(tempAvailable, 1)
        For j = 0 To UBound(tempAvailable, 2)
            tempAvailable(i, j) = (i + 1) * 2 & "," & (j + 1) * 2
        Next j
    Next i
    
    Dim listAvailable() As String
    ReDim listAvailable(0 To ((UBound(tempAvailable, 1) + 1) * (UBound(tempAvailable, 2) + 1)) - 1)
    For i = 0 To UBound(listAvailable)
        listAvailable(i) = tempAvailable(i Mod ((UBound(maze, 1) - 2) / 2), i \ ((UBound(maze, 1) - 2) / 2))
    Next i
    
    Do While listAvailable(0) <> vbNullString '�v�f����0�ɂȂ�܂�
        
        j = 0
        
        '�����_���Ɏ��o��
        Randomize
        i = Int((UBound(listAvailable) - 0 + 1) * Rnd + 0)
        str2coordinate listAvailable(i), vTemp, hTemp
        
        
        '��x�g�p���ꂽ�v�f�͐؂���
        '�v�f����0�ɂȂ�Ƃ��AlistAvailable(0)��vbNullString����������
        listAvailable = CloseGap(listAvailable, i)

        If maze(vTemp, hTemp) = False Then
            '�܂��ʘH�̏ꍇ�A�ǐL�΂�����
            
            '�w����W��ǂ�
            maze(vTemp, hTemp) = 2
'            DrawMaze maze

                
            Do While True
                
                Randomize
                Direction = Int((4 - 1 + 1) * Rnd + 1)
                
                If vTemp = 0 Or hTemp = 0 Then '���܂�0�ɂȂ�o�O����������̂őΏǗÖ@
                    Exit Do
                End If
                
                Select Case Direction
                    Case 1 '�k
                        If maze(vTemp - 2, hTemp) = 1 Then '�i�s�悪�����̕ǂ̏ꍇ
                            maze(vTemp - 1, hTemp) = 2
                            Exit Do
                        ElseIf maze(vTemp - 2, hTemp) = 0 Then '�ʘH�̏ꍇ
                            maze(vTemp - 1, hTemp) = 2
                            maze(vTemp - 2, hTemp) = 2
                            
                            vTemp = vTemp - 2
                            hTemp = hTemp
                            
                            BoolReset bool
                            
                            If flag(1) = True Or flag(2) = True Or flag(3) = True Then
                                BoolSwitch flag, 0
                                j = 0
                            Else
                                bool(0) = True
                                j = j + 1
                            End If
                            
                        ElseIf maze(vTemp - 2, hTemp) = 2 Then '���ݒ��̕ǂ̏ꍇ
                            bool(0) = True
                        End If
                        
                    Case 2 '��
                        If maze(vTemp, hTemp + 2) = 1 Then '�i�s�悪�����̕ǂ̏ꍇ
                            maze(vTemp, hTemp + 1) = 2
                            Exit Do
                        ElseIf maze(vTemp, hTemp + 2) = 0 Then '�ʘH�̏ꍇ
                            maze(vTemp, hTemp + 1) = 2
                            maze(vTemp, hTemp + 2) = 2
                            
                            vTemp = vTemp
                            hTemp = hTemp + 2
                            
                            BoolReset bool
                                                        
                            If flag(0) = True Or flag(2) = True Or flag(3) = True Then
                                BoolSwitch flag, 1
                                j = 0
                            Else
                                flag(1) = True
                                j = j + 1
                            End If
                            
                        ElseIf maze(vTemp, hTemp + 2) = 2 Then '���ݒ��̕ǂ̏ꍇ
                            bool(1) = True
                        End If
                    
                    Case 3 '��
                        If maze(vTemp + 2, hTemp) = 1 Then '�i�s�悪�����̕ǂ̏ꍇ
                            maze(vTemp + 1, hTemp) = 2
                            Exit Do
                        ElseIf maze(vTemp + 2, hTemp) = 0 Then '�ʘH�̏ꍇ
                            maze(vTemp + 1, hTemp) = 2
                            maze(vTemp + 2, hTemp) = 2
                            
                            vTemp = vTemp + 2
                            hTemp = hTemp
                            
                            BoolReset bool
                                                        
                            If flag(0) = True Or flag(1) = True Or flag(3) = True Then
                                BoolSwitch flag, 2
                                j = 0
                            Else
                                flag(2) = True
                                j = j + 1
                            End If
                            
                        ElseIf maze(vTemp + 2, hTemp) = 2 Then '���ݒ��̕ǂ̏ꍇ
                            bool(2) = True
                        End If
                        
                    Case 4 '��
                        If maze(vTemp, hTemp - 2) = 1 Then '�i�s�悪�����̕ǂ̏ꍇ
                            maze(vTemp, hTemp - 1) = 2
                            Exit Do
                        ElseIf maze(vTemp, hTemp - 2) = 0 Then '�ʘH�̏ꍇ
                            maze(vTemp, hTemp - 1) = 2
                            maze(vTemp, hTemp - 2) = 2
                            
                            vTemp = vTemp
                            hTemp = hTemp - 2
                            
                            BoolReset bool
                                                        
                            If flag(0) = True Or flag(1) = True Or flag(2) = True Then
                                BoolSwitch flag, 3
                                j = 0
                            Else
                                flag(3) = True
                                j = j + 1
                            End If
                            
                        ElseIf maze(vTemp, hTemp - 2) = 2 Then '���ݒ��̕ǂ̏ꍇ
                            bool(3) = True
                        End If
                    
                End Select
                
                If bool(0) = True And bool(1) = True And bool(2) = True And bool(3) = True Then
                    
                    
                    If flag(0) = True Then
                        vTemp = vTemp + 2 * (j + 1)
                    ElseIf flag(1) = True Then
                        hTemp = hTemp - 2 * (j + 1)
                    ElseIf flag(2) = True Then
                        vTemp = vTemp - 2 * (j + 1)
                    ElseIf flag(3) = True Then
                        hTemp = hTemp + 2 * (j + 1)
                    Else
                        
                        '�Q������̒��S�ɂȂ��Ă��܂������Ȃ�
                        '����ł͂ǂ����A�����炢�����킩��Ȃ��̂ŁA
                        '�n�_�ɖ߂��Ă�����ĉ^�ǂ��ǂ����̕ǂɐڒn����̂��肤
                        '���̐�����߂ĐV���ȓ_����n�߂�
                        
                        Randomize
                        Select Case Int(2 * Rnd + 1)
                            Case 1
                                vTemp = vStart
                                hTemp = hStart
                            Case 2
                                Exit Do
                        End Select
                        
                    End If
                    
                    BoolReset bool
                    BoolReset flag
                End If
                
                DrawMaze maze
                
                DoEvents
                
            Loop
            
            j = 0
            BoolReset bool
            BoolReset flag
            
            '���ݒ�=2�̕ǂ�1��
            For i = LBound(maze, 1) To UBound(maze, 1)
                For j = LBound(maze, 2) To UBound(maze, 2)
                    If maze(i, j) = 2 Then
                        maze(i, j) = 1
                        
'                        '���_�̂������ɕǂɂȂ������̂�listAvailable����폜
'                        If i Mod 2 = 0 And j Mod 2 = 0 Then
'                            listAvailable = CloseGapByVal(listAvailable, i & "," & j)
'                        End If
                        
                    End If
                Next j
            Next i
            
            DrawMaze maze
            
        End If
        
    Loop
    
End Function

Function DrawMaze(ByRef maze() As Integer)
    
    Range(Cells(LBound(maze, 1) + 1, LBound(maze, 2) + 1), Cells(UBound(maze, 1) + 1, UBound(maze, 2) + 1)).Rows.RowHeight = 5 * 0.75
    Range(Cells(LBound(maze, 1) + 1, LBound(maze, 2) + 1), Cells(UBound(maze, 1) + 1, UBound(maze, 2) + 1)).Columns.ColumnWidth = 5 * 0.07
    
    Dim i As Long
    Dim j As Long
    
    '0 : �������Ȃ�
    '1 : RGB(0,0,0)
    
    For i = LBound(maze, 1) To UBound(maze, 1)
        For j = LBound(maze, 2) To UBound(maze, 2)
            If maze(i, j) = 1 Then
                Cells(i + 1, j + 1).Interior.Color = RGB(0, 0, 0)
            ElseIf maze(i, j) = 2 Then
                Cells(i + 1, j + 1).Interior.Color = RGB(255, 0, 0)
            End If
        Next j
    Next i
    
    Cells(UBound(maze, 1) + 2, UBound(maze, 2) + 2).Select
    
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

Function BoolSwitch(ByRef arr() As Boolean, ByVal num As Long)
    
    Dim i As Long
    For i = LBound(arr) To UBound(arr)
        If i = num Then
            arr(i) = True
        Else
            arr(i) = False
        End If
    Next i
    
End Function

Function str2coordinate(ByVal str As String, ByRef vertical As Long, ByRef horizontal As Long)

    vertical = CLng(Left(str, InStr(str, ",") - 1))
    horizontal = CLng(Mid(str, InStr(str, ",") + 1))
    
End Function

'�Y����num���폜
'�������v�f����1(�Y����0)�̏ꍇ�A���e��vbNullString�ɂ���
Function CloseGap(ByRef arr() As String, ByVal num As Long) As String()
    
    Dim i As Long
    Dim flag As Boolean
    flag = False '�����܂�false�A�߂�����True
    Dim copy() As String
    
    If UBound(arr) = 0 Then
        ReDim copy(0 To 0)
        copy(0) = vbNullString
        CloseGap = copy
        Exit Function
    End If
    
    For i = LBound(arr) To UBound(arr)
        If i <> num Then
            If flag = False Then
                ReDim Preserve copy(LBound(arr) To i)
                copy(i) = arr(i)
            Else
                ReDim Preserve copy(LBound(arr) To i - 1)
                copy(i - 1) = arr(i)
            End If
        Else
            flag = True
        End If
    Next i
    
    CloseGap = copy
    
End Function

'�������v�f����1(�Y����0)�̏ꍇ�A���e��vbNullString�ɂ���
Function CloseGapByVal(ByRef arr() As String, ByVal val As String) As String()
    
    Dim i As Long
    Dim flag As Boolean
    flag = False '�����܂�false�A�߂�����True
    Dim copy() As String
    
    If UBound(arr) = 0 Then
        ReDim copy(0 To 0)
        copy(0) = vbNullString
        CloseGapByVal = copy
        Exit Function
    End If
    
    For i = LBound(arr) To UBound(arr)
        If arr(i) <> val Then
            If flag = False Then
                ReDim Preserve copy(LBound(arr) To i)
                copy(i) = arr(i)
            Else
                ReDim Preserve copy(LBound(arr) To i - 1)
                copy(i - 1) = arr(i)
            End If
        Else
            flag = True
        End If
    Next i
    
    CloseGapByVal = copy
    
End Function

'���0���c���Ă����K�v������
'�Y������1����n�܂�
'listCandidate����Range���폜
Function RangeArrDelete(ByRef arr() As Range, ByVal target As Range) As Range()
    
    Dim i As Long
    Dim copy() As Range
    Dim flag As Boolean
    flag = False
    
    For i = LBound(arr) + 1 To UBound(arr)
        If arr(i).Row = target.Row And arr(i).Column = target.Column Then
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

Function SetNext(ByVal target As Range) As Range
    
    
    '�I�𒆂̐F : 0,255,255
    '�T���ς݂̐F : 192,192,192
    
    '���E�㉺�̐i�s�\�Z�����}�[�L���O
    
    Dim Directions(0 To 3) As Range
    Set Directions(0) = target.Cells(0, 1)
    Set Directions(1) = target.Cells(1, 2)
    Set Directions(2) = target.Cells(2, 1)
    Set Directions(3) = target.Cells(1, 0)
    
    Dim i As Long
    
    For i = 0 To 3
        If Directions(i).Interior.Color = RGB(255, 0, 0) Then '�S�[���ɂ��ǂ�����ꍇ
            AllCellsChecked
            Get2Start = True
            Exit Function
        End If
        If IsAvailable(Directions(i)) Then '�ǂ��T���ς݂ł͂Ȃ��ꍇ
            
            Directions(i).Interior.Color = RGB(0, 255, 255)
            Directions(i).Value = target.Value + 1
            
            '�Y������1����n�܂�A0�ɂ͋󔒂̃f�[�^
            '�v�f����0�ɂȂ�Ƃ܂�������
            
            ReDim Preserve listCandidate(0 To UBound(listCandidate) + 1)
            Set listCandidate(UBound(listCandidate)) = Directions(i)
            
        End If
    Next i
    
    If target.Interior.Color <> Start.Interior.Color Then
        target.Interior.Color = RGB(192, 192, 192)
        listCandidate = RangeArrDelete(listCandidate, target)
    End If
    
End Function

Function GetNext() As Range
    Dim i As Long
    Dim minimum As Long
    minimum = (size + 2) ^ 2
    
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

Function IsAvailable(ByVal target As Range) As Boolean
    
    If target.Interior.Color <> RGB(0, 0, 0) And target.Interior.Color <> RGB(0, 255, 255) And target.Interior.Color <> RGB(192, 192, 192) And target.Interior.Color <> RGB(0, 255, 0) Then
        IsAvailable = True
    End If
    
End Function

'�ċA�ŃX�^�[�g�܂ŋA��
Function Back2Start(ByVal target As Range) As Range
    
    Dim Directions(0 To 3) As Range
    Set Directions(0) = target.Cells(0, 1)
    Set Directions(1) = target.Cells(1, 2)
    Set Directions(2) = target.Cells(2, 1)
    Set Directions(3) = target.Cells(1, 0)
    
    Dim i As Long
    
    For i = 0 To 3 '4�����ɃX�^�[�g������ΏI��
        If Directions(i).Interior.Color = RGB(0, 255, 0) Then
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
        If cell.Interior.Color = RGB(0, 255, 255) Then
            cell.Interior.Color = RGB(192, 192, 192)
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
