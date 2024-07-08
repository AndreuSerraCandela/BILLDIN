pageextension 92134 CustomerExtension extends "Customer Card"
{
    layout
    {
        addafter("IC Partner Code")
        {
            field("IdBilldIn"; Rec."IdBilldIn")
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter("Bank Accounts")
        {
            action("Sincronizar BilldIn")
            {
                ApplicationArea = All;
                Image = ExportContact;
                trigger OnAction()
                var
                    BilldIn: Codeunit "BilldIn";
                begin
                    if Rec."IdBilldIn" = '' then begin
                        rec.IdBilldIn := BilldIn."Billdin-Add-Contact"(Rec."No.", 'client');
                        rec.Modify();
                    end;

                end;
            }
        }
        addafter("Bank Accounts_Promoted")
        {
            actionref(Sincroniza; "Sincronizar BilldIn") { }
        }
    }
}
pageextension 92135 CustomerListExtension extends "Customer List"
{

    actions
    {
        addafter("Bank Accounts")
        {
            action("Lista Contactos")
            {
                ApplicationArea = All;
                Image = ImportCodes;
                trigger OnAction()
                var
                    BilldIn: Codeunit "BilldIn";
                    Vendor: Record Customer;
                begin
                    BilldIn."Billdin-Get-Contact-List"();

                end;
            }
            action("Sincronizar BilldIn")
            {
                ApplicationArea = All;
                Image = ExportContact;
                trigger OnAction()
                var
                    BilldIn: Codeunit "BilldIn";
                    Vendor: Record Customer;
                begin
                    Vendor.SetFilter(IdBilldIn, '%1', '');
                    If Vendor.FindSet() then
                        repeat
                            Vendor.IdBilldIn := BilldIn."Billdin-Add-Contact"(Vendor."No.", 'client');
                            Vendor.Modify();
                        until Vendor.Next() = 0;

                end;
            }
        }
        addafter("PaymentRegistration_Promoted")
        {
            actionref(Sincroniza; "Sincronizar BilldIn") { }
        }
    }
}