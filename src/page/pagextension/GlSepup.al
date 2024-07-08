pageextension 90131 ConfKuara extends "General Ledger Setup"
{
    layout
    {
        addlast(Content)
        {
            group(Billdin)
            {
                field("Ocr Url Api"; Rec."Ocr Url Api")
                {
                    ApplicationArea = All;
                }
                field("Api Key"; Rec."Api Key")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}