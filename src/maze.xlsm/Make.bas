Attribute VB_Name = "Make"
Option Explicit

Function MakeMaze()

    '�ǌ����Ǘ�
    Dim Knots() As Range
    ReDim Knots(0 To 0)
    '�V�K�ǂ��Ǘ�
    Dim TempWalls() As Range
    ReDim TempWalls(0 To 0)
    
    '���H�̏�����
    RangeMaze.Rows.RowHeight = 5 * 0.75
    RangeMaze.Columns.ColumnWidth = 5 * 0.07
    
    Cells(SIZE + 1, SIZE + 1).Select
    
    '�O�����(������)��
    RangeMaze.Interior.Color = BUILT
    Range(RangeMaze.Cells(2, 2), RangeMaze.Cells(RangeMaze.Rows.Count - 1, RangeMaze.Columns.Count - 1)).ClearFormats
    
    Dim i As Long
    Dim j As Long
    
    '�ǌ��(x,y�Ƃ�����g�ł͂Ȃ�)�̃��X�g���쐬
    For i = 3 To SIZE - 2 Step 2
        For j = 3 To SIZE - 2 Step 2
            
            ReDim Preserve Knots(0 To UBound(Knots) + 1)
            Set Knots(UBound(Knots)) = Cells(i, j)
            
        Next j
    Next i
    
    Dim prev As Long
    prev = UBound(Knots) - 1
    Application.StatusBar = "���H�𐶐����Ă��܂�... - 0%"
        
    Dim Selected As Range
    
    Dim temp As Long
    Dim Direction As Long
    Dim CantEnter(NORTH To WEST) As Boolean '�i�߂Ȃ��ꍇ��true
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    Dim Target As Range '�i�s��
    
    Do While True
        
        i = 0
        
        '�ǌ�₩�烉���_���Ɏ��o��
        'Int((�ő�l - �ŏ��l + 1) * Rnd + �ŏ��l)
        Randomize
        temp = Int((UBound(Knots) - (LBound(Knots) + 1) + 1) * Rnd + (LBound(Knots) + 1))
        
        Set Selected = Knots(temp)
        
        vTemp = Selected.Row
        hTemp = Selected.Column
        
        '���ǐL�΂�����
        '�ǌ���V�K�ǂ�
        Selected.Interior.Color = BUILDING
        ReDim Preserve TempWalls(0 To UBound(TempWalls) + 1)
        Set TempWalls(UBound(TempWalls)) = Selected
        
        '�i�s�����������_���Ɍ���
        BoolReset CantEnter
        
        Do While True
        
            Randomize
            Direction = Int((WEST - NORTH + 1) * Rnd + NORTH)
            
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
            
            If Target.Interior.Color = BUILT Then '�i�s�悪�����ǂ̏ꍇ
                '�i�s���V�K�ǂɂ��Ċm��
                Range(Cells(vTemp, hTemp), Target).Interior.Color = BUILDING
                
                ReDim Preserve TempWalls(0 To UBound(TempWalls) + 1)
                Set TempWalls(UBound(TempWalls)) = Range(Cells(vTemp, hTemp), Target)
                
                Exit Do
                
            ElseIf Target.Interior.Color = BUILDING Then '�V�K�ǂ̏ꍇ
                '�i�s�s�t���O�𗧂Ă�
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
                '�i�s���V�K�ǂɂ���
                Range(Cells(vTemp, hTemp), Target).Interior.Color = BUILDING
                
                ReDim Preserve TempWalls(0 To UBound(TempWalls) + 1)
                Set TempWalls(UBound(TempWalls)) = Range(Cells(vTemp, hTemp), Target)
                
                '�g�p���ꂽ�ǌ��̓��X�g����폜
                If UBound(Knots) <> 1 Then
                    Knots = ArrDelete(Knots, Target)
                    Application.StatusBar = "���H�𐶐����Ă��܂�... - " & Round((prev - UBound(Knots)) / prev, 2) * 100 & "%"
                Else
                    Knots = ArrDelete(Knots, Target)
                    Application.StatusBar = "���H�𐶐����Ă��܂�... - 100%"
                    Exit Function
                End If
                
                vTemp = Target.Row
                hTemp = Target.Column
                
                BoolReset CantEnter
                
            End If
            
            If CantEnter(NORTH) = True And CantEnter(EAST) = True And CantEnter(SOUTH) = True And CantEnter(WEST) = True Then '�S�Ă̕����ɐi�s�s�̏ꍇ
                '�V�K�ǂ��m�肵�ĐV���Ȍ������
                Exit Do
            End If
            
            DoEvents
        Loop
        
        
        '�V�K�ǂ��m��
        For i = LBound(TempWalls) + 1 To UBound(TempWalls)
            TempWalls(i).Interior.Color = BUILT
        Next i
        ReDim TempWalls(0 To 0)
        
        '�g�p���ꂽ�ǌ��̓��X�g����폜
        If UBound(Knots) <> 1 Then
            Knots = ArrDelete(Knots, Selected)
            Application.StatusBar = "���H�𐶐����Ă��܂�... - " & Round((prev - UBound(Knots)) / prev, 2) * 100 & "%"
        Else
            Knots = ArrDelete(Knots, Selected)
            Application.StatusBar = "���H�𐶐����Ă��܂�... - 100%"
            Exit Do
        End If
        
        DoEvents
    Loop
    
End Function
