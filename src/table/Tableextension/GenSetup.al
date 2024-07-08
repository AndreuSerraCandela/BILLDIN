/// <summary>
/// TableExtension ConfKuara (ID 80131) extends Record General Ledger Setup.
/// </summary>
tableextension 90131 ConfKuara extends "General Ledger Setup"
{
    fields
    {
        field(92100; "Ocr Url Api"; Text[250])
        {
            Caption = 'Url Api Ocr';
            DataClassification = ToBeClassified;
        }

        field(92127; "Api Key"; Text[1024])
        {
            Caption = 'Api Key';

        }

    }

    var
        myInt: Integer;
}