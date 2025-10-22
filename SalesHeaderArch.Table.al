tableextension 50102 "SOL Sales Header Archive Ext" extends "Sales Header Archive"
{
    fields
    {
        field(50100; "SOL Quote Status"; Enum "SOL Won/LostStatus")
        {
            Caption = 'Won/Lost Quote Status';
            DataClassification = CustomerContent;
        }
        field(50101; "SOL Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "SOL Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("SOL Quote Status" = CONST(Won)) "Close Opportunity Code".Code WHERE(Type = CONST(Won))
            ELSE IF ("SOL Quote Status" = CONST(Lost)) "Close Opportunity Code".Code WHERE(Type = CONST(Lost));
        }
        field(50103; "SOL Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("SOL Won/Lost Reason Code")));
            Editable = false;
        }
        field(50104; "SOL Won/Lost Remarks"; Text[2048])
        {
            Caption = 'Won/Lost Remarks';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}