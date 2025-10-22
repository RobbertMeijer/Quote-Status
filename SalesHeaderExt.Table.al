tableextension 50100 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Won/Lost Quote Status"; Enum "SOL Won/LostStatus")
        {
            Caption = 'Won/Lost Quote Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if xRec."Won/Lost Quote Status" <> Rec."Won/Lost Quote Status" then
                    "Won/Lost Date" := CurrentDateTime;
            end;
        }
        field(50101; "Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Won/Lost Quote Status" = CONST(Won)) "Close Opportunity Code".Code WHERE(Type = CONST(Won))
            ELSE IF ("Won/Lost Quote Status" = CONST(Lost)) "Close Opportunity Code".Code WHERE(Type = CONST(Lost));

            trigger OnValidate()
            begin
                TestWonLostReasonCode();
                CalcFields("Won/Lost Reason Desc.");
            end;
        }
        field(50103; "Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("Won/Lost Reason Code")));
            Editable = false;
        }
        field(50104; "Won/Lost Remarks"; Text[2048])
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
        CloseOpportunityCode: Record "Close Opportunity Code";

    local procedure TestWonLostReasonCode()
    begin
        if "Won/Lost Reason Code" = '' then
            exit;

        CloseOpportunityCode.Get("Won/Lost Reason Code");
        case "Won/Lost Quote Status" of
            "Won/Lost Quote Status"::Won:
                if CloseOpportunityCode.Type <> CloseOpportunityCode.Type::Won then
                    Error('You must select a Won reason code when the status is Won');
            "Won/Lost Quote Status"::Lost:
                if CloseOpportunityCode.Type <> CloseOpportunityCode.Type::Lost then
                    Error('You must select a Lost reason code when the status is Lost');
        end;
    end;
}