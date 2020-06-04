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
            
            '�Y������1����n�܂�A0�ɂ͋󔒂̃f�[�^
            '�v�f����0�ɂȂ�Ƃ܂�������
            
            ReDim Preserve Candidates(0 To UBound(Candidates) + 1)
            Set Candidates(UBound(Candidates)) = Directions(i)
            
        End If
    Next i
    
    If Target.Interior.Color <> START.Interior.Color Then
        Target.Interior.Color = SEARCHED
        Candidates = ArrDelete(Candidates, Target)
    End If
    
End Function

'���ɒT������Z����I��
Function SearchGet() As Range
    
    Dim i As Long
    Dim minimum As Long
    minimum = 2147483647
    
    Dim vTemp As Long
    Dim hTemp As Long
    
    For i = LBound(Candidates) + 1 To UBound(Candidates)
        'If minimum >= Candidates(i).Value + CLng(Sqr((Abs(Candidates(i).Row - Goal.Row)) ^ 2 + (Abs(Candidates(i).Row - Goal.Row)) ^ 2)) Then '�X�^�[�g����̋���+�S�[���܂ł̋���(��������)
        If minimum >= Candidates(i).Value + Abs(Candidates(i).Row - GOAL.Row) + Abs(Candidates(i).Row - GOAL.Row) Then '�X�^�[�g����̋���+�S�[���܂ł̋���(�ӂ̍��v)
            minimum = Candidates(i).Value + CLng(Sqr((Abs(Candidates(i).Row - GOAL.Row)) ^ 2 + (Abs(Candidates(i).Row - GOAL.Row)) ^ 2))
            
            Set SearchGet = Candidates(i)
            
        End If
    Next i
    
End Function

'�X�^�[�g�܂ŋA��
Function Back2Start(ByVal Target As Range) As Range
    
    Dim Directions(NORTH To WEST) As Range
    Set Directions(NORTH) = Target.Cells(0, 1)
    Set Directions(EAST) = Target.Cells(1, 2)
    Set Directions(SOUTH) = Target.Cells(2, 1)
    Set Directions(WEST) = Target.Cells(1, 0)
    
    Dim i As Long
    Dim val(NORTH To WEST) As Long
    
    For i = NORTH To WEST '4�����ɃX�^�[�g������ΏI��
        If Directions(i).Interior.Color = START.Interior.Color Then
            Solved = True
            Exit Function
        End If
        
        val(i) = CastValue(Directions(i).Value) '�e�Z���̒l(�X�^�[�g�܂ł̋���)���i�[
        
    Next i
    
    Dim s As Long
    s = Smallest(val) '�e�Z���̒l���ł����������̂�I��
    Directions(s).Interior.Color = ROUTE
    
    Set Back2Start = Directions(s)
    
End Function


