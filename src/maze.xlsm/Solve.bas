Attribute VB_Name = "Solve"
Option Explicit

'�l����T��
'�T������Z���̃��X�g���쐬
Function SearchSet(ByVal Target As Range) As Boolean
    
    SearchSet = False
    
    '���E�㉺�̐i�s�\�Z�����}�[�L���O
    
    Dim Directions(NORTH To WEST) As Range
    Set Directions(NORTH) = Target.Cells(0, 1)
    Set Directions(EAST) = Target.Cells(1, 2)
    Set Directions(SOUTH) = Target.Cells(2, 1)
    Set Directions(WEST) = Target.Cells(1, 0)
    
    Dim i As Long
    
    For i = NORTH To WEST
        If Directions(i).Interior.Color = GOAL.Interior.Color Then '�S�[���ɂ��ǂ�����ꍇ
            AllCellsChecked
            SearchSet = True
            Exit Function
        End If
        If IsAvailable(Directions(i)) Then '�ǂ��T���ς݂��X�^�[�g�ł͂Ȃ��ꍇ
            
            Directions(i).Interior.Color = SEARCHING
            Directions(i).Value = Target.Value + 1
            
            TempSearch = ArrAdd(TempSearch, Directions(i))
            
        End If
    Next i
    
    '�T���ς݂̃Z�������X�g����폜
    If Target.Interior.Color <> START.Interior.Color Then
        Target.Interior.Color = SEARCHED
        TempSearch = ArrDelete(TempSearch, Target)
    End If
    
End Function

'���ɒT������Z����I��
Function SearchGet() As Range
    
    Dim i As Long
    Dim Minimum As Long
    Minimum = 2147483647
    Dim Maximum As Long
    Maximum = 0
    
    Dim Minimums() As Range
    ReDim Minimums(0 To 0)
    
    Dim Evaluation As Long
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    For i = LBound(TempSearch) + 1 To UBound(TempSearch)
    
        Evaluation = TempSearch(i).Value + Abs(TempSearch(i).Row - GOAL.Row) + Abs(TempSearch(i).Row - GOAL.Row)  '�X�^�[�g����̋���+�S�[���܂ł̋���(�ӂ̍��v)
        'TempSearch(i).Value + CLng(Sqr((Abs(TempSearch(i).Row - GOAL.Row)) ^ 2 + (Abs(TempSearch(i).Row - GOAL.Row)) ^ 2)) '�X�^�[�g����̋���+�S�[���܂ł̋���(��������)
        
        If Minimum >= Evaluation Then
            
            If Minimum > Evaluation Then '�ŏ����X�V����ꍇ
                Minimum = Evaluation
                ReDim Minimums(0 To 0)
                Minimums = ArrAdd(Minimums, TempSearch(i))
            Else '�ŏ��ɕ��Ԃ��̂��������ꍇ
                Minimums = ArrAdd(Minimums, TempSearch(i))
            End If
            
        End If
    Next i
    
    For i = LBound(Minimums) + 1 To UBound(Minimums)
        
        Evaluation = Minimums(i).Value
        
        If Maximum < Evaluation Then '�X�^�[�g����̈ʒu����ԉ������̂�T��(�������ꍇ�͍ŏ��Ɍ��������̂ɂȂ�)
            Maximum = Evaluation
            
            Set SearchGet = Minimums(i)
            
        End If
        
    Next i
    
End Function

Function SolveSet(ByVal Target As Range) As Boolean
    
    SolveSet = False
    
    '���E�㉺�̃Z������A�e�Z���̒l(�X�^�[�g�܂ł̋���)�����������̂�I��
    
    Dim Directions(NORTH To WEST) As Range
    Set Directions(NORTH) = Target.Cells(0, 1)
    Set Directions(EAST) = Target.Cells(1, 2)
    Set Directions(SOUTH) = Target.Cells(2, 1)
    Set Directions(WEST) = Target.Cells(1, 0)
    
    Dim i As Long
    Dim val(NORTH To WEST) As Long
    
    For i = NORTH To WEST '4�����ɃX�^�[�g������ΏI��
        If Directions(i).Interior.Color = START.Interior.Color Then
            SolveSet = True
            Exit Function
        End If
        
        val(i) = CastValue(Directions(i).Value) '�e�Z���̒l(�X�^�[�g�܂ł̋���)���i�[
        
    Next i
    
    Dim s As Long
    s = Smallest(val) '�e�Z���̒l���ł����������̂�I��
    Set TempRoute = Directions(s)
    
End Function

Function SolveGet() As Range
    
    TempRoute.Interior.Color = ROUTE
    Set SolveGet = TempRoute
    
End Function
